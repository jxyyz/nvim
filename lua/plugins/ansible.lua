local P = {
    "pearofducks/ansible-vim",
    ft = { "yaml", "ansible" },
    config = function()
        require("ansible").setup()
    end,
}

return P
