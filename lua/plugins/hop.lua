local P = {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
        keys = 'tnseriaofwpgjluydqbzxmkhcv',
        multi_windows = true,
    },
    keys = {
        { "<leader>s", vim.cmd.HopWord,  desc = "Hop to word", silent = true },
        { "<leader>s", vim.cmd.HopWord,  mode = "v", desc = "Hop to word (visual mode)", silent = true },
        { "<leader>t", vim.cmd.HopChar2, desc = "Hop to 2-char pattern",   silent = true },
        { "<leader>t", vim.cmd.HopChar2, mode = "v", desc = "Hop to 2-char pattern (visual mode)", silent = true },
        { "<leader>T", vim.cmd.HopChar1, desc = "Hop to single character", silent = true },
        { "<leader>T", vim.cmd.HopChar1, mode = "v", desc = "Hop to single character (visual mode)", silent = true },
    },

}

return P
