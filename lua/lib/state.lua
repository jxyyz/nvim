-- lib/state.lua
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
