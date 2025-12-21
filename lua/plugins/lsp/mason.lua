local P = {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {},
}

return P

