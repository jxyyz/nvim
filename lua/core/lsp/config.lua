-- LSP config
local M = {}

M.features = {
    inlay_hints = {
        enabled = false,
        filetypes = { markdown = false },
    },
    semantic_tokens = {
        enabled = true,
        filetypes = {},
    }
}

function M.init()
    vim.diagnostic.config({
        virtual_lines = { current_line = true },
        virtual_text = false,
        float = {
            border = "rounded",
            source = "if_many",
            header = "",
        },
        update_in_insert = false,
        severity_sort = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
        }
    })
end

return M
