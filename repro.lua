-- repro.lua

-- Just trivial setup (install lazy.nvim, set mapleader, etc.)
-- source: https://github.com/jxyyz/nvim/blob/main/lua/repro/core.lua
local R = require("repro.core")

-- BUG REPPRODUCTION:
local spec = {
    {
        "folke/snacks.nvim",
        lazy = false,
        opts = {
            picker = { enabled = true },
            input = { enabled = true },

        },
    },
    {
        "MSmaili/wiremux.nvim",
        lazy = false,
        opts = {
            targets = {
                definitions = {
                    cc = { cmd = "claude", kind = "pane", title = "cc", shell = false },
                }
            },
        },
        keys = function()
            local w = require("wiremux")
            return {
                {
                    "<leader>awc",
                    function()
                        w.send({
                            { label = "A", value = "{selection}" },
                            { label = "B", value = "{selection}" },
                        })
                    end,
                    mode = { "n", "x" },
                    desc = "Foobar"
                }
            }
        end
    }
}

require("lazy").setup({
        spec = spec,
        root = R.plugin_dir,
        lockfile = R.lockfile,
        state = R.lazy_state,
        checker = { enabled = false },
        change_detection = { enabled = false },
})

print("Running isolated repro in: " .. R.root)
