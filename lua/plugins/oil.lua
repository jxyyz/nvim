-- TODO: toggle file detail view (recipe on github)
local remap = function()
	local oil = require("oil.actions")

	return {
		{ '<leader>aav', oil.select_vsplit.callback, desc = "Open file in vertival split" },
		{ '<leader>aas', oil.select_split.callback,  desc = "Open file in horizontal split" },
		{ '<leader>aar',  oil.refresh.callback,       desc = "Refresh oil view" },
	}
end

local P = {
	'stevearc/oil.nvim',
	lazy = false,
	opts = {
		keymaps = {
			["<C-h>"] = false,
			["<C-l>"] = false,
		},
		watch_for_changes = true,
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = remap,
}

return P

