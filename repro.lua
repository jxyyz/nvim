-- Just trivial setup (install lazy.nvim, set mapleader, etc.)
local R = require("repro.core")

-- BUG REPPRODUCTION:
require("lazy").setup({}, 
{
    root = R.plugin_dir,
    lockfile = R.lockfile,
    state = R.lazy_state,
    checker = { enabled = false },
    change_detection = { enabled = false },
})

print("Running isolated repro in: " .. R.root)
