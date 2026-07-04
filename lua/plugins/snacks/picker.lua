-- ===============
--  SNACKS PICKER
-- ===============
local h = require("plugins.snacks._picker")
local p = h.pick

local opts = {
	matcher = {
		frecency = true,
		history_bonus = true,
	},
}

local keys = {
	{ "<leader><leader>", p("files", { hidden = true, ignored = false }), desc = "Find files (including hidden)" },
	{ "<leader>fw", p("grep"), desc = "Find text in files (grep)" },
	{ "<leader>fa", p("files", { dirs = { "~" }, hidden = true }), desc = "Find files from home directory" },
	{
		"<leader>fi",
		p("files", { hidden = true, ignored = true }),
		desc = "Find all files (including hidden/ignored)",
	},
	{ "<leader>fe", p("explorer", { focus = "input" }), desc = "Open file explorer" },
	{ "<leader>fd", h.zoxide_with_smart_save, desc = "Find session by directory (zoxide)" },
	{ "<leader>bb", p("buffers"), desc = "Find buffers" },
	{ "<leader>fb", p("buffers"), desc = "Find buffers" },
	{ "<leader>fh", p("help"), desc = "Find help tags" },
	{ "<leader>fP", p("pickers"), desc = "Find Snacks Picker sources" },
	{ "<leader>fk", p("keymaps"), desc = "Find keymaps" },
	{ "<leader>ft", p("todo_comments"), desc = "Find TODO comments" },
	{ "<leader>fc", p("treesitter"), desc = "Find treesitter symbols" },
    -- TODO: create picker to find string across whole git history
	-- { "<leader>fgg", p(""), desc = "Grep Git History" },
	{ "<leader>fgb", p("git_branches"), desc = "Git Branches" },
	{ "<leader>fgl", p("git_log"), desc = "Git Log" },
	{ "<leader>fgL", p("git_log_line"), desc = "Git Log Line" },
	{ "<leader>fgs", p("git_status"), desc = "Git Status" },
	{ "<leader>fgS", p("git_stash"), desc = "Git Stash" },
	{ "<leader>fgd", p("git_diff"), desc = "Git Diff (Hunks)" },
	{ "<leader>fgf", p("git_log_file"), desc = "Git Log File" },
}

return { opts = opts, keys = keys }
