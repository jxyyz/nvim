local eh                = require("lib.ext"):setup("plugins.snacks")
local e, e_keys         = eh.e, eh.e_keys
local enabled, disabled = { enabled = true }, { enabled = false }

-- merge keys
local function mkeys(modules, extra_keys)
    local merged = {}
    for _, module_name in ipairs(modules) do
        vim.list_extend(merged, e_keys(module_name))
    end

    if extra_keys then
        vim.list_extend(merged, extra_keys)
    end
    return merged
end

local P = {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker = e(enabled, "picker"),
        dim = {
            enabled = true,
            animate = {
                enabled = true,
                easying = "inOutSine",
            },
        },
        bigfile = { enabled = true },
        input = { enabled = true },
        scroll = { enabled = false },
        indent = { enabled = false },
        image = { enabled = true },
    },
    keys = mkeys({ 'picker' }),

    -- init = function()
    --     local Snacks = require("snacks")
    --     Snacks.dim()
    -- end,
}


return P
