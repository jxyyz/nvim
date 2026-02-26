local P = {
    "jxyyz/wiremux.nvim",
    lazy = false,
    opts = {
        targets = {
            definitions = {
                cc = { cmd = "claude", kind = "pane", title = "cc", shell = false },
            }
        },
        picker = {
            instances = {
                filter = function(inst, state)
                    return inst.origin_cwd == vim.fn.getcwd()
                end,
            }
        }
    },

    keys = function()
        local w = require("wiremux")
        return {
            { "<leader>awt", w.toggle, desc = "Toggle target" },
            {
                "<leader>awa",
                function()
                    w.send("/ask {input:Question}\n\ncontext:\n{this}")
                end,
                mode = { "n", "x" },
                desc = "Ask"
            },
            {
                "<leader>awc",
                function()
                    w.send({
                        { label = "CSC update", value = "/csc-update", submit = true },
                        { label = "clear",      value = "/clear",      submit = true },
                    })
                end,
                desc = "Clean up"
            },
        }
    end
}

return P
