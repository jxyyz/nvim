--  This is the function that propagates `motion`, ignoring buffers of specified type
local function move(motion)
    local ignore_filetypes = {"snacks_layout_box", "snacks_picker_input", "snacks_picker_list",}

    return function()
        local buftype = "nofile"
        vim.g.last_pane = vim.fn.win_getid()
        vim.cmd(motion)
        if vim.bo.buftype ~= buftype
          or vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.g.last_pane = vim.fn.win_getid()
        else
            while vim.bo.buftype == buftype do
                local jumped_to = vim.fn.win_getid()
                vim.cmd(motion)
                if vim.fn.win_getid() == jumped_to then
                    vim.fn.win_gotoid(vim.g.last_pane)
                    break
                end
            end
        end
    end
end

local P = {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>", move("TmuxNavigateLeft") },
        { "<c-j>", move("TmuxNavigateDown") },
        { "<c-k>", move("TmuxNavigateUp") },
        { "<c-l>", move("TmuxNavigateRight") },
        { "<c-\\>", move("TmuxNavigatePrevious") },
    },
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
        vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
    config = function()
        local group = vim.api.nvim_create_augroup("TmuxNavigator", { clear = true })
        vim.api.nvim_create_autocmd(
            { "VimEnter", "FocusGained", "TabEnter" },
            {
                group = group,
                pattern = "*",
                callback = function()
                    if vim.g.last_pane then
                        vim.fn.win_gotoid(vim.g.last_pane)
                    end
                end,
                desc = "Focus on last pane when switching from tmux",
            }
        )
    end,
}

return P
