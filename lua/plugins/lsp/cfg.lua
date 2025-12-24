local P = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "saghen/blink.cmp",
        "folke/lazydev.nvim"
    },
    config = function()end,
}


return P
