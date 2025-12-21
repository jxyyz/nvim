local onstart_group = vim.api.nvim_create_augroup("OnStart", { clear = true })

-- Show notification on startup
-- e.g. when nvim is restarted with <leader>rr
vim.api.nvim_create_autocmd("VimEnter", {
    group = onstart_group,
    callback = function()
        local notify_msg = os.getenv("NVIM_NOTIFY")
        if notify_msg then
            vim.defer_fn(function()
                vim.notify(notify_msg, vim.log.levels.INFO)
            end, 350)
        end
    end,
})
