local helpers = require("core.lsp._remap")
local function snacks_picker (source, opts)
    return function()
        Snacks.picker.pick(source, opts)
    end
end


local function remap(opts)
    local bufnr = opts.bufnr
    local buff = opts.features.buffer[bufnr]
    local h = helpers:init(opts)

    local map_all, map_if = h.map_all, h.map_if

    -- ═══════════════════════════════════════════
    -- NAVIGATION (g)
    -- ═══════════════════════════════════════════
    map_if('textDocument/definition', snacks_picker("lsp_definitions"), {
        { 'n', 'grd',         'Definition' },
        { 'n', '<leader>lgd', 'Definition [grd]' },
    })

    map_if('textDocument/declaration', snacks_picker("lsp_declarations"), {
        { 'n', 'grD',         'Declaration' },
        { 'n', '<leader>lgD', 'Declaration [grD]' },
    })

    map_if('textDocument/implementation', snacks_picker("lsp_implementations"), {
        { 'n', 'gri',         'Implementation' },
        { 'n', '<leader>lgi', 'Implementation [gri]' },
    })

    map_if('textDocument/typeDefinition', snacks_picker("lsp_type_definitions"), {
        { 'n', 'grt',         'Type definition' },
        { 'n', '<leader>lgt', 'Type definition [grt]' },
    })

    map_if('textDocument/references', snacks_picker("lsp_references"), {
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
        { 'n', '[d',          function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Prev diagnostic' },
        { 'n', ']d',          function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next diagnostic' },
        { 'n', '<leader>ldo', vim.diagnostic.open_float, 'Open float [<C-W>d]' },
        { 'n', '<leader>ldp', function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Prev diagnostic `[d`' },
        { 'n', '<leader>ldn', function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next diagnostic `]d`' },
        { 'n', '<leader>lda', snacks_picker("diagnostics"), "Diagnostics (picker)"},
        { 'n', '<leader>ldb', snacks_picker("diagnostics", {filter = {buf=bufnr}}), "Buffer diagnostics (picker)"},
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
    local format = function() vim.lsp.buf.format({ async = true, bufnr = bufnr }) end

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
    map_if('textDocument/documentSymbol', snacks_picker("lsp_symbols"), {
        { 'n', 'gO',          'Document symbols' },
        { 'n', '<leader>lsd', 'Document symbols [gO]' },
    })

    map_if('workspace/symbol', snacks_picker("lsp_workspace_symbols"), {
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
    map_all({
        {'n', '<leader>ltv', function()
            local vl = vim.diagnostic.config().virtual_lines
            if vl ~= false then
                vl = false
            else
                vl = { current_line = true }
            end

            vim.diagnostic.config({ virtual_lines = vl })
        end, 'Toggle diagnostic virtual_lines'}
    })
    if buff.inlay_hints then
        map_all({
            { 'n', '<leader>lth', function()
                buff.inlay_hints:toggle()
            end, 'Toggle inlay hints' },
        })
    end

    if buff.semantic_tokens then
        map_all(
            { { 'n', '<leader>lts', function()
                buff.semantic_tokens:toggle()
            end, 'Toggle semantic tokens' }, }
        )
    end

end

return remap
