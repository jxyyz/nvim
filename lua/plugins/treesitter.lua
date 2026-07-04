local P = {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        -- Neovim 0.11 shim: nvim-treesitter main uses vim.list.unique() (0.12+). Remove on 0.12.
        if not vim.list then
            vim.list = {
                unique = function(t)
                    local seen, out = {}, {}
                    for _, v in ipairs(t) do
                        if not seen[v] then
                            seen[v] = true
                            out[#out + 1] = v
                        end
                    end
                    return out
                end,
            }
        end

        local ts = require("nvim-treesitter")

        ts.install({
            "lua", "vim", "vimdoc", "query",
            "python", "rust", "go", "javascript", "typescript", "bash", "fish",
            "yaml", "json", "toml",
            "markdown", "markdown_inline", "html", "latex", "typst",
            "vhs", "nu",
            "jinja", "jinja_inline",
        }):wait(60000)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
            callback = function(ev)
                local ft = ev.match

                -- ansible-vim's setup() owns treesitter for `ansible` buffers
                if ft == "ansible" then
                    return
                end

                pcall(vim.treesitter.start, ev.buf)
            end,
        })
    end,
}
return P
