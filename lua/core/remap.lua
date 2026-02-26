local util = require("lib.util")
local map = vim.keymap.set

-- Set leader key to space
vim.g.mapleader = " "

-- Save and restart neovim
-- WARN: requires shell to handle 42 exit code (eg. nvim func wraper)
map("n", "<leader>rr", function()
    vim.cmd("wall")
    vim.cmd("cquit 42")
end, { desc = "Save and Restart Neovim" })


-- File explorer
map("n", "<leader>pv", vim.cmd.Oil, { desc = "Open Oil file explorer" })

-- Clear search highlighting
map("n", "<ESC>", vim.cmd.nohl, { desc = "Clear search highlighting" })

-- Navigate help files - follow tags and links
map("n", "gh", "<C-]>", { desc = "Follow tag/link in help files" })

-- System clipboard operations
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
map("n", "<leader>yy", [["+yy]], { desc = "Copy line to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Copy from cursor to end of line to system clipboard" })

-- Moving lines up and down in visual mode
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

map("n", "<leader>mk", ":m -2<cr>", { desc = "Move current line up" })
map("n", "<leader>mj", ":m +1<CR>", { desc = "Move current line down" })
map("v", "<leader>mk", ":m '<-2<cr>gv=gv", { desc = "Move selected lines up" })
map("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Advanced paste operations
map("x", "<leader>p", [["_dP]], { desc = "Paste over selection (preserve register)" })
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete to black hole register (preserve clipboard)" })

-- Disable Ex mode
map("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- QUICKFIX & LOCATION LIST
map("n", "<A-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item (centered)" })
map("n", "<A-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item (centered)" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item (centered)" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item (centered)" })

-- Advanced text manipulation
map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Setup substitution for word under cursor" })
map("n", "<leader>x", "<cmd>!chmod +x %<CR>",
    { silent = true, desc = "Make current file executable" })

-- Cellular Automaton animations
-- map("n", "<leader>mr", ":CellularAutomaton make_it_rain<CR>",
--     { desc = "Run 'make it rain' animation" })
-- map("n", "<leader>ms", ":CellularAutomaton scramble<CR>",
--     { desc = "Run 'scramble' animation" })

-- Buffer management
map("n", "<leader>bd", vim.cmd.bd, { desc = "Delete current buffer" })
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Delete all buffers except current", silent=true})

-- Window management
map("n", "<leader>av", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>as", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>ac", ":q<CR>", { desc = "Close current window" })
map("n", "<leader>ao", ":only<CR>", { desc = "Close all windows except current" })
map("n", "<leader>al", ":call lens#toggle()<CR>", { desc = "Toggle lens (auto-resize)" })
map("n", "<leader>ar", util.reset_view, { desc = "Reset window layout"})

-- Window resize operations
local function res(s)
    return function()
        vim.cmd(s)
        vim.o.cmdheight = cmdheight
    end
end

map("n", "<S-j>", res("resize +5"), { silent = true, desc = "Increase window height" })
map("n", "<S-k>", res("resize -5"), { silent = true, desc = "Decrease window height" })
map("n", "<S-h>", res("vertical resize -5"), { silent = true, desc = "Decrease window width" })
map("n", "<S-l>", res("vertical resize +5"), { silent = true, desc = "Increase window height" })

-- Focus/zen/dim
map("n", "<leader>zz", function()
    local en = not Snacks.dim.enabled
    if en then Snacks.dim.enable() else Snacks.dim.disable() end
end, {desc = "Toggle dim mode"})

-- TODO:
-- git hunks remaps
