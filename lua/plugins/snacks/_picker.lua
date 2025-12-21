local M = {}

function M.pick(picker, opts, before, after)
    return function() 
        if before then 
            if not before() then return nil end
        end
        Snacks.picker.pick(picker, opts) 
        if after then after() end
    end
end

function M.zoxide_with_smart_save()
    -- Helper: logic of writing buffers and starting picker
    local function save_and_go()
        -- Save buffers
        vim.cmd("silent! wall")

        -- Save session
        local ok = pcall(function() vim.cmd("silent! AutoSession save") end)
        if not ok then vim.cmd("silent! mksession!") end

        vim.notify("Session saved ✓", vim.log.levels.INFO)

        --  Call picker
        Snacks.picker.zoxide()
    end

    -- Check if any unsaved buffers
    local modified_bufs = vim.fn.getbufinfo({ bufmodified = true })

    if #modified_bufs == 0 then
        -- CASE 1: All buffers saved -> Save session and continue
        save_and_go()
    else
        -- CASE 2: Not all buffers are saved -> Ask to save project or cancel zoxide picker
        vim.ui.select({"yes", "no"}, {prompt="Unsaved changes! Save project?"},
        function(input)
            if input == "yes" then
                save_and_go()
            end

            vim.notify("Session change canceled")
            return -- Cancel operation
        end)
    end
end

return M
