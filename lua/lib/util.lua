local M = {}

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
