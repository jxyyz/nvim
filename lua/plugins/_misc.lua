--
-- ╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮
-- │││├┤ │ │╰┐┌╯││││
-- ╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴
--
-- TODO: https://oneofone.dev/post/securing-neovim-with-firejail/
-- TODO: mini.starter
-- TODO: consider nvim ufo
-- TODO: mini.ai
-- TODO: surround
-- TODO: TreeSJ
-- TODO: git signs / blame / diff
-- TODO: proper LSP
-- TODO: cheatsheet plugin

-- DONE: quicker
-- DONE: tmux - sesh
-- DONE: fancy notifications
-- DONE: HOP
-- CANCELED: plugin for tip of the day
-- CANCELED: consider using detour.nvim

local P = {
    { 
        'j-hui/fidget.nvim', 
        lazy= false,
        opts = {
            notification = {
                override_vim_notify=true,
                window = {
                    x_padding = 4,
                    y_padding = 3,
                    avoid = {"no-neck-pain"},
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
                enableOnVimEnter = true,
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
                "nofile", "nowrite", "quickfix", "terminal", "prompt" ,
            })
        end,
    },

}

return P
