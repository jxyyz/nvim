--
-- ╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮
-- │││├┤ │ │╰┐┌╯││││
-- ╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴
--
-- TODO: treesitter setup
-- TODO: https://oneofone.dev/post/securing-neovim-with-firejail/
-- TODO: mini.ai
-- TODO: TreeSJ
-- TODO: git signs / blame / diff
-- TODO: "Hashino/doing.nvim",
-- TODO: consider luapad
-- TODO: other.nvim
-- TODO: dap
-- TODO: undotree


-- DONE: arrow (canceled: harpoon/chosen)
-- DONE: quicker
-- DONE: tmux - sesh
-- DONE: fancy notifications
-- DONE: HOP
-- DONE: proper LSP
-- DONE: "kosayoda/nvim-lightbulb",
-- DONE: surround
-- CANCELED: cheatsheet plugin
-- CANCELED: plugin for tip of the day
-- CANCELED: consider using detour.nvim
-- CANCELED: consider nvim ufo
-- CANCELED: mini.starter

local P = {
    {
        "lowitea/aw-watcher.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        'j-hui/fidget.nvim',
        lazy = false,
        opts = {
            notification = {
                override_vim_notify = true,
                window = {
                    x_padding = 4,
                    y_padding = 3,
                },
            },
        },
    },
    {
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        cmd = "NoNeckPain",
        event = "VimEnter",
        opts = {
            width = 120,
            autocmds = {
                enableOnVimEnter = "safe",
                skipEnteringNoNeckPainBuffer = true,
            },
        },
    },
    {
        "camspiers/lens.vim",
        event = "VeryLazy",
        dependencies = {
            -- NOTE: replaced with mini.animate which is async
            -- "camspiers/animate.vim",
        },
        config = function()
            vim.api.nvim_set_var("lens#disabled_filetypes", {
                "nerdtree", "tagbar", "DiffViewFiles", "dapui_watches", "dapui_scopes",
                "dapui_stacks", "dapui_breakpoints", "dapui_console", "dapui_repl",
                "snacks_layout_box", "snacks_picker_input", "snacks_picker_list",
            })
            vim.api.nvim_set_var("lens#disabled_buftypes", {
                "nofile", "nowrite", "quickfix", "terminal", "prompt",
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = false,
        opts = {}
    },
    {
        -- NOTE: there is a "code lens" support
        'kosayoda/nvim-lightbulb',
        event = "LspAttach",
        opts = {
            autocmd = {
                enabled = true,
                events = {"CursorHold"} ,
            },
        }
    },
    {
        "Hashino/doing.nvim",
        cmd = "Do",
        config = function()
            local doing = require("doing")
            doing.setup {
                doing_prefix = "   ",
                ignored_buffers = { "md", "dapui_scopes", "dapui_stacks", "dapui_watches", "dapui_repl", "dap-repl", "dapui_breakpoints", "dapui_console" },
                store = {
                    file_name = ".tasks",
                    sync_tasks = true,
                },
            }
        end,
        keys = {
            { "<leader>da", function() require("doing").add() end,          desc = "Add new task" },
            { "<leader>dA", function() require("doing").add(nil, true) end, desc = "Add new task (force)" },
            { "<leader>dn", function() require("doing").done() end,         desc = "Mark task as done" },
            { "<leader>de", function() require("doing").edit() end,         desc = "Edit task" },
        },
    },


}

return P
