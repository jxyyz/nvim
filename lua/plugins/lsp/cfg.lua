local remap = require("core.lsp.remap")
local config = require("core.lsp.config")

local P = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "saghen/blink.cmp",
        "folke/lazydev.nvim"
    },
    config = function()
        local lsp_attach_group = vim.api.nvim_create_augroup('lsp_attach', { clear = true })
        vim.api.nvim_create_autocmd('LspAttach', {
            group = lsp_attach_group,
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local bufnr = args.buf
                if not client then return end

                config({client=client, bufnr=bufnr, lsp_attach_group=lsp_attach_group})
                remap({client=client, bufnr=bufnr})
            end,
        })
    end,
}


return P
