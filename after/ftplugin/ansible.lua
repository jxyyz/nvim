local StrFg = "#c0c8c0"

if vim.fn.executable('ansible-doc') == 1 then
    vim.bo.keywordprg = ':sp term://ansible-doc'
end

vim.api.nvim_set_hl(0, '@string.yaml', { fg = StrFg })
vim.api.nvim_set_hl(0, '@boolean.yaml', { link = 'Boolean' })

-- ansible task keywords (ansible-vim setup() -> @keyword.ansible.*); linked to
-- theme groups so they track the colorscheme, with targets picked for distinct hues.
vim.api.nvim_set_hl(0, '@keyword.ansible.control',   { link = 'Statement' })
vim.api.nvim_set_hl(0, '@keyword.ansible.loop',      { link = 'Identifier' })
vim.api.nvim_set_hl(0, '@keyword.ansible.directive', { link = 'PreProc' })
vim.api.nvim_set_hl(0, '@keyword.ansible.debug',     { link = 'Debug' })
