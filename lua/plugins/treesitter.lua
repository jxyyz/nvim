local P = {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local ts = require("nvim-treesitter")

        ts.install({
            "lua", "vim", "vimdoc", "query",
            "python", "rust", "go", "javascript", "typescript", "bash", "fish",
            "yaml", "json", "toml",
            "markdown", "markdown_inline", "html", "latex", "typst",
            "mark",
        }):wait(60000)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
            callback = function(ev)
                local ft = ev.match

                if ft == "yaml.ansible" then
                    return
                end

                pcall(vim.treesitter.start, ev.buf)
            end,
        })
    end,
}
return P
