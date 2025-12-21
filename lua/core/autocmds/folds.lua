local save_fold_group = vim.api.nvim_create_augroup("SaveFolds", { clear = true })
local excluded_filetypes = { "oil", "neo-tree", "lazy", "TelescopePrompt", "mason", "snacks_layout_box", "snacks_picker_input", "snacks_picker_list",}

local function should_skip()
    if vim.bo.buftype ~= "" then
        -- skip if it's not regular file
        return true
    elseif (vim.fn.expand("%") == "" ) then
        -- skip if file has no name
        return true
    elseif vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
        -- finally check if filetype is excluded
        return true
    end

    return false
end

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = save_fold_group,
  pattern = "*",
  callback = function()
      if should_skip() then return end
      vim.cmd("silent! loadview")
  end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = save_fold_group,
  pattern = "*",
  callback = function()
      if should_skip() then return end
      vim.cmd("mkview")
  end,
})

