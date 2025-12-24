local state = require("lib.state")
local e = require("lib.ext"):setup("lib.lsp.features").e

local M = {}
M.buffer = {}

M.features = {
    inlay_hints = e("inlay_hints"),
    semantic_tokens = e("semantic_tokens"),

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
    self.buffer = state.buffer(
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
