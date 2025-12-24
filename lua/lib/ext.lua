-- Configuration extension helper with caching
-- 
-- Purpose: Load and merge configuration from external modules with optional keymap extraction.
-- Supports caching to avoid repeated requires and flexible module path configuration.
--
-- Usage:
--   local cfg = require("lib.utils.ext"):setup("plugins.snacks")
--   
--   -- Merge table with external module config
--   cfg.e("picker")                           -- Load all from plugins.snacks.picker
--   cfg.e({}, "picker")                       -- Load all from plugins.snacks.picker
--   cfg.e({foo="bar"}, "picker")              -- Merge table with plugins.snacks.picker
--   cfg.e({foo="bar"}, {baz="qux"})           -- Merge two tables directly
--   cfg.e({foo="bar"}, "picker", {baz="qux"}) -- Merge table + module + extra table
--   
--   -- Extract keymaps from module
--   cfg.e_keys("picker")                      -- Return .keys from plugins.snacks.picker
--   cfg.e_keys("picker", {})                  -- Return .keys or empty table if missing
--
-- Features:
--   - Module path can be configured per instance via :setup()
--   - Automatic caching prevents repeated module loads
--   - Supports merging tables, strings (module names), and multiple sources
--   - Deep merge using vim.tbl_deep_extend("force", ...)
--   - Optional default value for e_keys() when keys are missing
--
-- Examples:
--   -- snacks.nvim configuration
--   local snacks_cfg = require("lib.utils.ext"):setup("plugins.snacks")
--   
--   return {
--       "folke/snacks.nvim",
--       opts = {
--           picker = snacks_cfg.e({}, "picker"),
--           dim = snacks_cfg.e({}, "dim"),
--       },
--       keys = snacks_cfg.e_keys("picker"),
--   }
--
--   -- telescope.nvim with multiple merges
--   local telescope_cfg = require("lib.utils.ext"):setup("plugins.telescope")
--   
--   return {
--       "nvim-telescope/telescope.nvim",
--       opts = telescope_cfg.e({defaults={}}, "settings", {extensions={}}),
--       keys = telescope_cfg.e_keys("settings"),
--   }
--
--   -- lsp servers configuration
--   local lsp_cfg = require("lib.utils.ext"):setup("config.lsp")
--   
--   return lsp_cfg.e({}, "servers")  -- Ładuje config.lsp.servers
--

local function create_extension_helper(_, base_path, module_key)
    local _cache = {}

    base_path = base_path or nil
    module_key = module_key or "opts"

    local function load_module(name)
        local module_name = name

        if base_path ~= nil then
            module_name = base_path .. "." .. module_name
        end 

        if not _cache[module_name] then
            _cache[module_name] = require(module_name)
        end
        return _cache[module_name]
    end

    -- Merge multiple configuration sources (variadic)
    -- Each argument can be:
    --   - string: loaded as module via load_module(arg).opts
    --   - table:  merged directly
    -- Arguments are merged left-to-right; later values override earlier ones
    -- Examples:
    --   e("module")                      -> load module opts
    --   e({base=1}, "module", {x=2})     -> merge base + module opts + extra
    --   e("mod1", "mod2")                -> merge mod1 opts + mod2 opts
    --   e({}, {a=1}, {b=2})              -> merge tables directly
    local function e(...)
        local result = {}
        for i = 1, select("#", ...) do
            local arg = select(i, ...)
            local tbl = type(arg) == "string" and load_module(arg)[module_key] or arg
            result = vim.tbl_deep_extend("force", result, tbl or {})
        end
        return result
    end 

    -- Extract keys from module
    local function e_keys(module_name, default)
        return load_module(module_name).keys or default or {}
    end
    
    return {
        e = e,
        e_keys = e_keys,
    }
end

return {
    setup = create_extension_helper,
}

