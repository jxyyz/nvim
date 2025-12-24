local config = require("core.lsp.config")
local remap = require("core.lsp.remap")
local features = require("lib.lsp.features"):init(config.features)

local lsp_attach_group = vim.api.nvim_create_augroup('lsp_attach', { clear = true })

config.init()

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_attach_group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf
        if not client then return end

        features.buffer.init(bufnr)
        remap({bufnr=bufnr, client=client, features=features})

    end,
})
