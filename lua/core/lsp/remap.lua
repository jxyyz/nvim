local function remap(opts)
    -- ───────────────────────────────────────────
    -- Helpers
    -- ───────────────────────────────────────────
    local buff = vim.b[opts.bufnr]

    local function map_all(mappings)
        for _, m in ipairs(mappings) do
            vim.keymap.set(m[1], m[2], m[3], {
                buffer = opts.bufnr, noremap = true, silent = true, desc = m[4]
            })
        end
    end

    local function map_if(method, fn, mappings)
        if opts.client:supports_method(method) then
            for _, m in ipairs(mappings) do
                vim.keymap.set(m[1], m[2], fn, {
                    buffer = opts.bufnr, noremap = true, silent = true, desc = m[3]
                })
            end
        end
    end

    -- ═══════════════════════════════════════════
    -- NAVIGATION (g)
    -- ═══════════════════════════════════════════
    map_if('textDocument/definition', vim.lsp.buf.definition, {
        { 'n', 'grd',         'Definition' },
        { 'n', '<leader>lgd', 'Definition [grd]' },
    })

    map_if('textDocument/declaration', vim.lsp.buf.declaration, {
        { 'n', 'grD',         'Declaration' },
        { 'n', '<leader>lgD', 'Declaration [grD]' },
    })

    map_if('textDocument/implementation', vim.lsp.buf.implementation, {
        { 'n', 'gri',         'Implementation' },
        { 'n', '<leader>lgi', 'Implementation [gri]' },
    })

    map_if('textDocument/typeDefinition', vim.lsp.buf.type_definition, {
        { 'n', 'grt',         'Type definition' },
        { 'n', '<leader>lgt', 'Type definition [grt]' },
    })

    map_if('textDocument/references', vim.lsp.buf.references, {
        { 'n', 'grr',         'References' },
        { 'n', '<leader>lgr', 'References [grr]' },
    })

    -- ═══════════════════════════════════════════
    -- HOVER & SIGNATURE (h)
    -- ═══════════════════════════════════════════
    map_if('textDocument/hover', vim.lsp.buf.hover, {
        { 'n', 'K',           'Hover' },
        { 'n', '<leader>lhh', 'Hover [K]' },
    })

    map_if('textDocument/signatureHelp', vim.lsp.buf.signature_help, {
        { 'i', '<C-s>',       'Signature help' },
        { 'n', '<leader>lhs', 'Signature help [i_<C-S>]' },
    })

    -- ═══════════════════════════════════════════
    -- DIAGNOSTICS (d)
    -- ═══════════════════════════════════════════
    map_all({
        { 'n', '[d',          vim.diagnostic.goto_prev,  'Prev diagnostic' },
        { 'n', ']d',          vim.diagnostic.goto_next,  'Next diagnostic' },
        { 'n', '<leader>ldo', vim.diagnostic.open_float, 'Open float [<C-W>d]' },
        { 'n', '<leader>ldp', vim.diagnostic.goto_prev,  'Prev diagnostic `[d`' },
        { 'n', '<leader>ldn', vim.diagnostic.goto_next,  'Next diagnostic `]d`' },
    })

    -- ═══════════════════════════════════════════
    -- CODE ACTIONS (c)
    -- ═══════════════════════════════════════════
    map_if('textDocument/codeAction', vim.lsp.buf.code_action, {
        { 'n', 'gra',         'Code action' },
        { 'x', 'gra',         'Code action' },
        { 'n', '<leader>lca', 'Code action [gra]' },
        { 'x', '<leader>lca', 'Code action [gra]' },
    })

    -- ═══════════════════════════════════════════
    -- RENAME (r)
    -- ═══════════════════════════════════════════
    map_if('textDocument/rename', vim.lsp.buf.rename, {
        { 'n', 'grn',         'Rename' },
        { 'n', '<leader>lrn', 'Rename [grn]' },
    })

    -- ═══════════════════════════════════════════
    -- FORMATTING (f)
    -- ═══════════════════════════════════════════
    local format = function() vim.lsp.buf.format({ async = true, bufnr = opts.bufnr }) end

    map_if('textDocument/formatting', format, {
        { 'n', '<leader>lff', 'Format buffer' },
        { 'x', '<leader>lff', 'Format selection' },
    })

    map_if('textDocument/rangeFormatting', format, {
        { 'x', '<leader>lfr', 'Format range' },
    })

    -- ═══════════════════════════════════════════
    -- SYMBOLS (s)
    -- ═══════════════════════════════════════════
    map_if('textDocument/documentSymbol', vim.lsp.buf.document_symbol, {
        { 'n', 'gO',          'Document symbols' },
        { 'n', '<leader>lsd', 'Document symbols [gO]' },
    })

    map_if('workspace/symbol', vim.lsp.buf.workspace_symbol, {
        { 'n', '<leader>lsw', 'Workspace symbols' },
    })

    -- ═══════════════════════════════════════════
    -- WORKSPACE (w)
    -- ═══════════════════════════════════════════
    map_all({
        { 'n', '<leader>lwa', vim.lsp.buf.add_workspace_folder,    'Add folder' },
        { 'n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove folder' },
        { 'n', '<leader>lwl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, 'List folders' },
    })

    -- ═══════════════════════════════════════════
    -- TOGGLES (t)
    -- ═══════════════════════════════════════════
    if buff.lsp.inlay_hints then
        map_all({
            { 'n', '<leader>lth', function()
                vim.b[opts.bufnr].lsp.inlay_hints:toggle()
            end, 'Toggle inlay hints' },
        })
    end

    if buff.lsp.semantic_tokens then
        map_all(
            { { 'n', '<leader>lts', function()
                vim.b[opts.bufnr].lsp.semantic_tokens:toggle()
            end, 'Toggle semantic tokens' }, }
        )
    end

end

return remap
