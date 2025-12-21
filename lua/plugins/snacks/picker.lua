-- ===============
--  SNACKS PICKER
-- ===============
local h = require("plugins.snacks._picker")
local p = h.pick

local opts = {
    matcher = {
        frecency = true,
        history_bonus = true,
    },
}

local keys = {
    {"<leader><leader>", p("files", {hidden=true, ignored=false}), desc = "Find files (including hidden)"},
    {"<leader>fw", p("grep"), desc = "Find text in files (grep)"},
    {"<leader>fa", p("files", {dirs={"~"}, hidden=true}), desc = "Find files from home directory"},
    {'<leader>fi', p("files", {hidden=true, ignored=true}), desc = "Find all files (including hidden/ignored)"},
    {'<leader>fe', p("explorer", {focus="input"}), desc = "Open file explorer"},
    {'<leader>fd', h.zoxide_with_smart_save, desc = "Find session by directory (zoxide)"},
    {'<leader>bb', p("buffers"), desc = "Find buffers"},
    {'<leader>fb', p("buffers"), desc = "Find buffers"},
    {'<leader>fh', p("help"), desc = "Find help tags"},
    {'<leader>fP', p("pickers"), desc = "Find Snacks Picker sources"},
    {'<leader>fk', p("keymaps"), desc = "Find keymaps"},
    -- TODO: rewrite for snacks
    -- {'<leader>fc', builtin.treesitter, desc = "Find treesitter symbols"},
    -- {'<leader>ft', vim.cmd.TodoTelescope, desc = "Find TODO comments"},

}

return {opts=opts, keys=keys}
