-- Just trivial setup (install lazy.nvim, set mapleader, etc.)
local R = require("repro.core")

require("lazy").setup({
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            picker = {enable=true}
        },
        keys = {
            { "<leader><leader>", function() Snacks.picker.pick("pickers") end, desc = "Test Pickers" }
        }
    },
    {
        "camspiers/lens.vim",
        event = "VeryLazy",
        dependencies = {
            -- "camspiers/animate.vim",
        },
        config = function()
            vim.api.nvim_set_var("lens#disabled_filetypes", {
                "nerdtree", "tagbar", "DiffViewFiles", "dapui_watches", "dapui_scopes",
                "dapui_stacks", "dapui_breakpoints", "dapui_console", "dapui_repl", 
                "snacks_picker_input", "snacks_picker_list",
            })
            vim.api.nvim_set_var("lens#disabled_buftypes", {
                "nofile", "nowrite", "quickfix", "terminal", "prompt" ,
            })
        end,
    },
{
    "nvim-mini/mini.nvim", 
    event = "VeryLazy",
    version = false,
    config = function()
        require("mini.animate").setup()
    end,
}, 
}, 
{
    root = R.plugin_dir,
    lockfile = R.lockfile,
    state = R.lazy_state,
    checker = { enabled = false },
    change_detection = { enabled = false },
})

print("Running isolated repro in: " .. R.root)
