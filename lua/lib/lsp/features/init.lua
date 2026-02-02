-- Custom LSP feature management.
--
-- Implements the toggle/configure logic for individual LSP features,
-- each defined in its own sub-module. State is tracked per-buffer via
-- lib.state and auto-applied on buffer attach.
--
-- `core/lsp/*` consumes this module to wire features into keymaps and config.

local state = require("lib.state")
local e = require("lib.ext"):setup("lib.lsp.features").e

local M = {}
M.buffer = {}

M.features = {
    -- Register features with its logic and default configuration
    inlay_hints = e("inlay_hints"),
    semantic_tokens = e("semantic_tokens"),

    -- NOTE: Helper method. 
    -- Initialize each feature with provided `auto_apply` ability.
    _auto_apply = function(self, bufnr)
        for _, k in ipairs(vim.tbl_keys(self)) do
            if string.sub(k, 1, 1) ~= "_" then
                if self[k].auto_apply and self[k].apply then
                    self[k]:apply(bufnr)
                end
            end
        end
    end
}



function M:init (config)
    -- Create buffer registry for storing state.
    -- Each buffer with attached LSP has it's own binding 
    -- of LSP features.
    self.buffer = state.buffer(
        -- Merge default configuration with provided configuration.
        e(self.features, config),
        {
            on_create = function(bufnr, instance)
                instance:_auto_apply(bufnr)
            end
        }
    )

    return self
end

return M
