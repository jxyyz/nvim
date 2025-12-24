local clue = require("mini.clue")

local opts = {
    window = {
        config = {
            width = 80,
        },
    },
    triggers = {
        -- leader triggers
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },

        -- `[` and `]` keys
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- `s` key
        { mode = 'n', keys = 's' },
        { mode = 'x', keys = 's' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
    },


    clues = {
        -- General
        { mode = 'n', keys = '<leader>a',  desc = '+Window +Oil' },
        { mode = 'n', keys = '<leader>aa', desc = '+Oil' },
        { mode = 'n', keys = '<leader>b',  desc = '+Buffer' },
        { mode = 'n', keys = '<leader>f',  desc = '+Picker' },
        { mode = 'n', keys = '<leader>w',  desc = '+Session' },

        -- Moving lines and selection
        { mode = 'n', keys = '<leader>m',  desc = '+VisMove' },
        { mode = 'n', keys = '<leader>mj', postkeys = '<leader>m' },
        { mode = 'n', keys = '<leader>mk', postkeys = '<leader>m' },

        { mode = 'x', keys = '<leader>m',  desc = '+VisMove' },
        { mode = 'x', keys = '<leader>mj', postkeys = '<leader>m' },
        { mode = 'x', keys = '<leader>mk', postkeys = '<leader>m' },

        -- LSP
        { mode = 'n', keys = '<leader>l',  desc = '+LSP' },
        { mode = 'n', keys = '<leader>lg', desc = '+Go to' },
        { mode = 'n', keys = '<leader>lh', desc = '+Hover/Help' },
        { mode = 'n', keys = '<leader>ld', desc = '+Diagnostics' },
        { mode = 'n', keys = '<leader>lc', desc = '+Code actions' },
        { mode = 'n', keys = '<leader>lr', desc = '+Rename' },
        { mode = 'n', keys = '<leader>lf', desc = '+Format' },
        { mode = 'n', keys = '<leader>ls', desc = '+Symbols' },
        { mode = 'n', keys = '<leader>lw', desc = '+Workspace' },
        { mode = 'n', keys = '<leader>lt', desc = '+Toggles' },

        { mode = 'n', keys = '<leader>z',  desc = '+Zen/Focus' },


        clue.gen_clues.square_brackets(),
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
    },
}

local keys = {}

return { opts = opts, keys = keys }
