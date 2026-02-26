local M = {}

function M.reset_view()
    pcall(function()vim.cmd("NoNeckPainResize 120")end)
    vim.o.cmdheight = vim.g.default_cmdheight
end

function M.debounce(fn, ms)
    ms = ms or 20
    local timer = assert(vim.uv.new_timer())
    return function(...)
        local argv = { ... }
        timer:stop()
        timer:start(ms, 0, vim.schedule_wrap(function()
            fn(unpack(argv))
        end))
    end
end

return M
