local P = {
    "otavioschwanck/arrow.nvim",
    keys = { "<CR>" },
    opts = {
        show_icons = true,
        leader_key = '<CR>',     -- Recommended to be a single key
        buffer_leader_key = 'm', -- Per Buffer Mappings
        index_keys = "traniopfwluy;czm,./h",
        mappings = {
            edit = "e",
            delete_mode = "d",
            clear_all_items = "C",
            toggle = "s", -- used as save if separate_save_and_remove is true
            open_vertical = "v",
            open_horizontal = "-",
            quit = "q",
            remove = "x", -- only used if separate_save_and_remove is true
            next_item = "]",
            prev_item = "["
        },
    }

}

return P
