-- local StrFg = "#51b579"
local StrFg = "#eff2ef"

vim.defer_fn(function()
    vim.api.nvim_set_hl(0, 'yamlBool', {
        link = "Boolean",
    })
    vim.api.nvim_set_hl(0, 'yamlFlowString', {
        fg = StrFg
    })
    vim.api.nvim_set_hl(0, 'yamlPlainScalar', {
        fg = StrFg
    })
    vim.api.nvim_set_hl(0, 'yamlBlockString', {
        fg = StrFg
    })
end, 100)
