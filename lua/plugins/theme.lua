local P = {
    {
        "EdenEast/nightfox.nvim" ,
        lazy = false,
        config = function()
            vim.cmd.colorscheme "carbonfox"
        end,
    },
}

return P


-- **OTHER**
--
-- {
--     'navarasu/onedark.nvim',
--     lazy = false,
--     config = function()
--         require('onedark').setup({
--             style = 'deep',
--         })
--         vim.cmd.colorscheme "onedark"
--     end,
-- },
-- {
--     "tiagovla/tokyodark.nvim",
--     lazy = false,
--     opts = {
--         gamma = 0.9,
--     },
--     config = function(_, opts)
--         require("tokyodark").setup(opts)
--         vim.cmd.colorscheme "tokyodark"
--     end,
-- }
-- {
-- "decaycs/decay.nvim",
-- name = "decay",
-- lazy = false,
-- config = function ()
--     require("decay").setup({
--         style = "decay-dark",
--         italics = {
--             code = true,
--             comments = true,
--         },
--         nvim_tree = {
--             contrast = true,
--         },
--     })
--     vim.cmd.colorscheme "decay"
-- end
-- },
