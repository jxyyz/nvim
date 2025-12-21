-- GENERAL GROUP
local general_group = vim.api.nvim_create_augroup("General", { clear = true })

-- highgligh on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = general_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- quick quit with `q` instead of `:q`
vim.api.nvim_create_autocmd("FileType", {
    group = general_group,
    pattern = {
        "help",
        "man",
        "query",        -- Treesitter playground
        "checkhealth",
        "lspinfo",      -- LSP status info
        "plenary",      -- Plenary test popups
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    end,
})

-- Open help always in vertical split on the right
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = general_group,
  pattern = "*",
  callback = function()
      if vim.bo.filetype == "help" then
          vim.cmd("wincmd L")  
      end
  end,
})



-- autowrap text buffers (no code)
vim.api.nvim_create_autocmd("FileType", {
    group = general_group,
    pattern = { "gitcommit", "markdown", "text", "log" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = false
    end,
})
