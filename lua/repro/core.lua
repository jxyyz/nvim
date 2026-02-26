require("core.autocmds.onstart")

local M = {}
local map = vim.keymap.set

M.root = "/tmp/nvim-repro"
M.plugin_dir = M.root .. "/plugins"
M.lockfile = M.root .. "/lazy-lock.json"
M.lazy_state = M.root .. "/lazy-state.json"

M.lazypath = M.plugin_dir .. "/lazy.nvim"


vim.fn.mkdir(M.plugin_dir, "p")

if not (vim.uv or vim.loop).fs_stat(M.lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, M.lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(M.lazypath)

vim.g.mapleader = " "
map("n", "<leader>ao", ":only<CR>")
map("n", "<leader>as", ":split<CR>")
map("n", "<leader>av", ":vsplit<CR>")
-- Save and restart neovim
-- WARN: requires shell to handle 42 exit code (eg. nvim func wraper)
map("n", "<leader>rr", function()
    vim.cmd("wall")
    vim.cmd("cquit 42")
end, { desc = "Save and Restart Neovim" })

vim.defer_fn(function()
    vim.cmd("e /tmp/nvim-test.txt")
end, 100)

return M
