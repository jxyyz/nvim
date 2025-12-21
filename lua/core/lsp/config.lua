local state = require("lib.state")

local M = state.buffer(
    function(bufnr)
        return {
            bufnr = bufnr,
            inlay_hints = {enabled = false},
            semantic_tokens = {ensabled = true}, 
        }
    end
)

M.inlay_hints = M.feature("inaly_hints", {
    toggle = function (s, f)
       f.enabled = not f.enabled
       vim.lsp.inlay_hint.enable(f.enabled, {bufnr=s.bufnr})
    end,

    enable = function (s, f)
       f.enabled = true 
       vim.lsp.inlay_hint.enable(true, {bufnr=s.bufnr})
    end,

    disable = function (s, f)
       f.enabled = false 
       vim.lsp.inlay_hint.enable(false, {bufnr=s.bufnr})
    end,

    is_enabled = function(_, f)
        return f.enabled
    end
})

local function config(opts)
    local llsp = vim.b[opts.bufnr].lsp or {}

    -- --
    -- auto-hide inlay hints in insert mode
    if opts.client:supports_method('textDocument/inlayHint') then
        llsp.inlay_hints = {
            _refresh = function(self)
                local lsp = vim.b[opts.bufnr].lsp
                lsp.inlay_hints = self
                vim.b[opts.bufnr].lsp = lsp
            end,
            is_enabled = false,

            enable = function(self)
                self.is_enabled = true
                vim.lsp.inlay_hint.enable(true, { bufnr = opts.bufnr })
                self:_refresh()
            end,

            disable = function(self)
                self.is_enabled = false
                vim.lsp.inlay_hint.enable(false, { bufnr = opts.bufnr })
                self:_refresh()
            end,

            toggle = function(self)
                if self.is_enabled then
                    self:disable()
                else
                    self:enable()
                end
            end,
        }

        vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
            buffer = opts.bufnr,
            group = opts.lsp_attach_group,

            callback = function(ev)
                if ev.event == "InsertEnter" then
                    vim.lsp.inlay_hint.enable(false, { bufnr = opts.bufnr }) 
                else
                    vim.lsp.inlay_hint.enable(llsp.inlay_hints.is_enabled, { bufnr = opts.bufnr }) 
                end
            end,
        })
    end

    -- --
    -- Sematnic tokens
    if opts.client:supports_method('textDocument/semanticTokens/full')
        or opts.client:supports_method('textDocument/semanticTokens/range') then

        llsp.semantic_tokens = {
            _refresh = function(self)
                local lsp = vim.b[opts.bufnr].lsp
                lsp.semantic_tokens = self
                vim.b[opts.bufnr].lsp = lsp
            end,
            is_enabled = true,

            enable = function(self)
                self.is_enabled = true
                vim.lsp.semantic_tokens.start(opts.bufnr, opts.client.id)
                self:_refresh()
            end,

            disable = function(self)
                self.is_enabled = false
                vim.lsp.semantic_tokens.stop(opts.bufnr, opts.client.id)
                self:_refresh()
            end,

            toggle = function(self)
                if self.is_enabled then
                    self:disable()
                else
                    self:enable()
                end
            end,
        }
    end

    -- --
    -- DOCUMENT HIGHLIGHTING
    -- if opts.client:supports_method('textDocument/documentHighlight') then
    --     local hl_group = vim.api.nvim_create_augroup('lsp_highlight_' .. opts.bufnr, { clear = true })
    --     vim.api.nvim_create_autocmd('CursorHold',
    --         { group = hl_group, buffer = opts.bufnr, callback = vim.lsp.buf.document_highlight })
    --     vim.api.nvim_create_autocmd('CursorMoved',
    --         { group = hl_group, buffer = opts.bufnr, callback = vim.lsp.buf.clear_references })
    -- end

    vim.b[opts.bufnr].lsp = llsp
end

return config
