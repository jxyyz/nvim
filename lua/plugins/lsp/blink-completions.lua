local P = {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    event = "VeryLazy",
    version = '1.*',

    opts = {
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        -- See :h blink-cmp-config-keymap
        keymap = { preset = 'default' }, -- <C-y> to accept

        appearance = {
            nerd_font_variant = 'normal' -- or mono
        },

        completion = { documentation = { auto_show = false } },

        sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100, 
                },
            },
        },

        -- typo resistance, etc.
        fuzzy = { implementation = "prefer_rust_with_warning" },

        signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
}

return P
