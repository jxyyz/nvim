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

local function create_extension_helper(_, base_path)
    local _cache = {}
    
    local function load_module(name)
        local module_name = base_path .. "." .. name
        if not _cache[module_name] then
            _cache[module_name] = require(module_name)
        end
        return _cache[module_name]
    end
    
    -- Merge multiple configuration sources
    -- e(string)               - load module only
    -- e(table, string, table) - merge starting table + module + extra table
    -- e(table, string)        - merge starting table + module
    -- e(table, table)         - merge two tables directly
    local function e(otbl, etbl, extra)
        if type(otbl) == "string" and not etbl and not extra then
            otbl, etbl = {}, otbl
        end
        if type(etbl) == "string" then etbl = load_module(etbl).opts end
        local result = vim.tbl_deep_extend("force", otbl, etbl or {})
        if extra then result = vim.tbl_deep_extend("force", result, extra) end
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

