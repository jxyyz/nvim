local eh = require("lib.ext"):setup("plugins.mini")
local e = eh.e

local P = {
    "nvim-mini/mini.nvim", 
    event = "VeryLazy",
    version = false,
    config = function()
        require("mini.pairs").setup()
        require("mini.surround").setup()
        require("mini.clue").setup(e("clue"))
        require("mini.animate").setup(e("animate"))
        require("mini.icons").setup()
        MiniIcons.mock_nvim_web_devicons()
    end,
} 

return P
