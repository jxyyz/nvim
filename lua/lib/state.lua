-- Keyed state registry with lifecycle management.
--
-- Problem:
--   Sometimes it's needed to manage some state across different usecases of
--   Neovim. There are buffer variables (vim.b), but they are wrappers over
--   Vimscript variables — Lua values are converted to Vimscript types on each
--   access, losing reference identity, functions, and metatables.
--
-- Solution:
--   Lua-native state tied to a scope (buffer, window, project) — created
--   lazily, keyed per-scope, and cleaned up automatically when the scope is
--   gone.
--
-- How it works:
--   1. Define a SCHEMA — a table template with properties and methods.
--   2. Call create(schema, opts) — you get a REGISTRY.
--   3. The registry lazily creates INSTANCES — each instance is a deep copy
--      of the schema, keyed by whatever you choose (bufnr, winid, path, ...).
--   4. Functions in the schema are auto-bound: fn(self, key, ...) so methods
--      always know which scope they belong to, without the caller passing it.
--   5. Instances are accessed transparently via registry[key] or registry.prop.
--
-- Quick start — counter per buffer:
--
--   local state = require("lib.state")
--   local counters = state.buffer({ count = 0 })
--
--   counters.count              -- get count for current buffer
--   counters[bufnr].count       -- get count for specific buffer
--   counters.count = 5          -- set count for current buffer
--
-- API:
--
--   create(schema, opts)
--     Core factory. Returns a registry backed by schema.
--     schema       — table template, deep-copied per instance
--     opts.default_key  — fun(): any — returns current scope key (e.g. bufnr)
--     opts.lifecycle    — optional lifecycle hooks (see below)
--     opts.defaults     — optional fun(key): table — fallback values when nil
--
--   Presets (convenience wrappers over create()):
--     buffer(schema, opts?)   — keyed by bufnr, auto-cleans on BufWipeout/BufUnload
--     window(schema, opts?)   — keyed by winid, auto-cleans on invalid window
--     tab(schema, opts?)      — keyed by tabpage id, auto-cleans on invalid tabpage
--     project(schema, opts?)  — keyed by project root path, persistent (no auto-cleanup)
--     global(schema)          — single instance, no keying
--
--   Lifecycle hooks (opts.lifecycle):
--     on_create(key, instance)  — after new instance is created; can return replacement
--     on_remove(key, instance)  — before instance is removed from cache
--     is_valid(key)             — returns boolean; invalid keys trigger lazy cleanup
--     validate_on               — list of autocmd events that trigger cache sweep
--
--   Access patterns:
--     registry[key]       — get instance for explicit key
--     registry.prop       — get property from current scope's instance
--     registry.prop = val — set property on current scope's instance
--     registry.init(key)  — explicitly create entry (alias for _get)
--
--   Internal methods:
--     _get(key), _remove(key), _keys(), _clear(), _sweep()
--
-- Custom state example (not limited to Neovim scopes):
--
--   local sessions = state.create({ active = false, data = {} }, {
--       default_key = function() return get_current_session_id() end,
--       lifecycle = {
--           is_valid = function(id) return is_session_alive(id) end,
--           on_create = function(id, inst) log("session created:", id) end,
--       },
--   })
--
-- Real-world example (from lib/lsp/features/):
--
--   -- Per-buffer LSP feature state
--   self.buffer = state.buffer(schema, {
--       on_create = function(bufnr, instance)
--           instance:_auto_apply(bufnr)
--       end,
--   })
--
--   -- In remap:
--   local buff = features.buffer[bufnr]
--   buff.inlay_hints:toggle()
--
-- Schema function binding:
--   Functions defined in the schema receive (self, key, ...). The key is
--   injected automatically by deep_copy_with_binding, so methods always know
--   their scope. Example: a schema method toggle(self, bufnr) — when called
--   as instance:toggle(), bufnr is filled in from the instance's key.
--
local util = require("lib.util")
local M = {}

---@class Lifecycle
---@field on_create? fun(key: any, instance: table)
---@field is_valid? fun(key: any): boolean   -- Optional, defaults to always true
---@field validate_on? [string] -- Optional, list of validation when to validate registry
---@field on_remove? fun(key: any, instance: table)

---@class CreateOpts
---@field default_key fun(): any
---@field lifecycle? Lifecycle
---@field defaults? fun(key: any): any -- Fallback values when nil

---@class PresetOpts
---@field on_create? fun(key: any, instance: table)
---@field on_remove? fun(key: any, instance: table)
---@field defaults? fun(key: any): any -- Fallback values when nil

---@class ProjectOpts : PresetOpts
---@field markers? string[]
---@field fallback? "cwd"|"file"

---Deep copy table, wrap functions with (self, key, ...) signature
---@param tbl table
---@param key any
---@return table
local function deep_copy_with_binding(tbl, key)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = deep_copy_with_binding(v, key)
        elseif type(v) == "function" then
            copy[k] = function(self, ...)
                return v(self, key, ...)
            end
        else
            copy[k] = v
        end
    end
    return copy
end

---Wrap instance with defaults fallback
---@param instance table
---@param defaults_fn fun(key: any): table
---@param key any
---@return table
local function with_defaults(instance, defaults_fn, key)
    return setmetatable(instance, {
        __index = function(_, k)
            local defaults = defaults_fn(key)
            return defaults[k]
        end,
    })
end

--------------------------------------------------
-- Core
--------------------------------------------------

---Create a scoped state registry
---@param schema table
---@param opts CreateOpts
---@return table
function M.create(schema, opts)
    local cache = {}
    local lifecycle = opts.lifecycle

    local function is_valid(key)
        if not lifecycle or not lifecycle.is_valid then
            return true
        end
        return lifecycle.is_valid(key)
    end



    local function remove_instance(key)
        if not cache[key] then return end
        if lifecycle and lifecycle.on_remove then
            lifecycle.on_remove(key, cache[key])
        end
        cache[key] = nil
    end

    local function get_instance(key)
        key = key or opts.default_key()
        if key == nil then return nil end

        -- Lazy cleanup
        if cache[key] and not is_valid(key) then
            remove_instance(key)
        end

        -- Create if needed
        if not cache[key] and is_valid(key) then
            local instance = deep_copy_with_binding(schema, key)
            if opts.defaults then
                instance = with_defaults(instance, opts.defaults, key)
            end

            cache[key] = instance

            -- Call hook
            if lifecycle and lifecycle.on_create then
                local result = lifecycle.on_create(key, cache[key])
                -- Replace instance, if hook returns something
                -- but hook can also mutate instance "in place"
                if result ~= nil then
                    cache[key] = result
                end
            end
        end

        return cache[key]
    end

    -- AUTO CLEANUP
    local state_group = vim.api.nvim_create_augroup("StateRegistry", { clear = true })
    local validation = opts.lifecycle and opts.lifecycle.validate_on
    if validation then
        vim.api.nvim_create_autocmd(validation, {
            group = state_group,
            callback = util.debounce(function()
                    for k in pairs(cache) do
                        if not is_valid(k) then
                            remove_instance(k)
                        end
                    end
                end, 50),
        })
    end


    return setmetatable({
        _get = get_instance,
        init = get_instance, -- alias for clarity; creates  entry
        _remove = remove_instance,
        _keys = function() return vim.tbl_keys(cache) end,
        _clear = function()
            for key in pairs(cache) do
                remove_instance(key)
            end
        end,
        _sweep = function()
            for key in pairs(cache) do
                if not is_valid(key) then
                    remove_instance(key)
                end
            end
        end,
    }, {
        __index = function(_, key)
            -- Explicit key: M[bufnr], M["path"]
            if type(key) == "number" or type(key) == "string" then
                local instance = get_instance(key)
                if instance then return instance end
            end
            -- Property access: M.inlay_hints
            local instance = get_instance()
            return instance and instance[key]
        end,

        __newindex = function(_, key, value)
            local instance = get_instance()
            if instance then
                instance[key] = value
            end
        end,
    })
end

--------------------------------------------------
-- Presets
--------------------------------------------------

---Buffer-scoped state
---@param schema table
---@param opts? PresetOpts
---@return table
function M.buffer(schema, opts)
    opts = opts or {}
    return M.create(schema, {
        default_key = vim.api.nvim_get_current_buf,
        lifecycle = {
            is_valid = vim.api.nvim_buf_is_valid,
            on_remove = opts.on_remove,
            on_create = opts.on_create,
            validate_on = { "BufWipeout", "BufUnload" }
        },
    })
end

---Window-scoped state
---@param schema table
---@param opts? PresetOpts
---@return table
function M.window(schema, opts)
    opts = opts or {}
    return M.create(schema, {
        default_key = vim.api.nvim_get_current_win,
        lifecycle = {
            is_valid = vim.api.nvim_win_is_valid,
            on_remove = opts.on_remove,
            on_create = opts.on_create,
        },
    })
end

---Tab-scoped state
---@param schema table
---@param opts? PresetOpts
---@return table
function M.tab(schema, opts)
    opts = opts or {}
    return M.create(schema, {
        default_key = vim.api.nvim_get_current_tabpage,
        lifecycle = {
            is_valid = vim.api.nvim_tabpage_is_valid,
            on_remove = opts.on_remove,
            on_create = opts.on_create,
        },
    })
end

---Project-scoped state (persistent, no auto-cleanup)
---@param schema table
---@param opts? ProjectOpts
---@return table
function M.project(schema, opts)
    opts = opts or {}
    local markers = opts.markers or { ".git", "package.json", "Cargo.toml", "go.mod", "pyproject.toml" }

    local function find_root()
        local path = vim.fn.expand("%:p:h")
        if path == "" then path = vim.fn.getcwd() end

        local root = vim.fs.root(path, markers)
        if root then return root end

        if opts.fallback == "cwd" then return vim.fn.getcwd() end
        if opts.fallback == "file" then return path end

        return nil
    end

    return M.create(schema, {
        default_key = find_root,
        -- No lifecycle = persistent
    })
end

---Global state (single instance)
---@param schema table
---@return table
function M.global(schema)
    local instance = deep_copy_with_binding(schema, "global")

    return setmetatable({}, {
        __index = function(_, key) return instance[key] end,
        __newindex = function(_, key, value) instance[key] = value end,
    })
end

return M
