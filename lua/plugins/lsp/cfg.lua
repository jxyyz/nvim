local P = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "saghen/blink.cmp",
        "folke/lazydev.nvim"
    },
    config = function()
        -- esp custom toolchain does not include rust-analyzer, force stable
        vim.lsp.config('rust_analyzer', {
            cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
            settings = {
                ['rust-analyzer'] = {
                    check = {
                        command = 'clippy',
                        extraArgs = { '--', '-D', 'warnings' },
                    },
                },
            },
        })
        vim.lsp.enable('rust_analyzer')

        -- ansiblels defaults to the yaml.ansible filetype; this config uses plain `ansible`
        vim.lsp.config('ansiblels', { filetypes = { 'ansible' } })

        -- nushell ships its own language server via `nu --lsp`;
        -- config comes from nvim-lspconfig's lsp/nushell.lua
        vim.lsp.enable('nushell')
    end,
}


return P
