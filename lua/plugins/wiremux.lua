local P = {
    "jxyyz/wiremux.nvim",
    branch = "stg",
    lazy = false,
    opts = {
        targets = {
            definitions = {
                cc = { cmd = "claude", kind = "pane", title = "cc", shell = false },
            }
        },
        picker = {
            instances = {
                -- Instances from current cwd
                filter = function(inst, state)
                    return inst.origin_cwd == vim.fn.getcwd()
                end,
            }
        }
    },

    keys = function()
        local w = require("wiremux")
        local send = function(prompt, opts)
            local _opts = { target = "cc", pre_keys = { "Escape", "i"}, post_keys="Enter"}
            local final_opts = vim.tbl_deep_extend("force", _opts, opts or {})

            return function()
                    w.send(prompt, final_opts)
            end
        end
        return {
            { "<leader>awt", w.toggle, desc = "Toggle target" },
            {
                "<leader>awa",
                send("/ask {input:Question}\n\ncontext:\n{this}"),
                mode = { "n", "x" },
                desc = "Ask"
            },
            {
                "<leader>aww",
                send("context (my cursor position when writing this):\n{this}\n\n{input:Prompt}"),
                mode = { "n", "x" },
                desc = "Prompt {this}"
            },
            {
                "<leader>awc",
                function()
                    w.send({
                        { label = "clear",      value = "/clear"},
                        { label = "CSC update", value = "/csc-update"},
                    }, { pre_keys = { "Escape", "i" }, post_keys ={ "Enter" }})
                end,
                desc = "Clean up"
            },
        }
    end
}

return P
