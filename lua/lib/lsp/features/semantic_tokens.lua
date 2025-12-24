local semantic_tokens = {
    enabled = true,
    filetypes = {},
    auto_apply = true,

    toggle = function (self, bufnr)
        self.enabled = not self.enabled
        self:apply(bufnr)
    end,

    enable = function (self, bufnr)
        self.enabled = true
        self:apply(bufnr)
    end,

    disable = function (self, bufnr)
        self.enabled = false
        self:apply(bufnr)
    end,

    apply = function (self, bufnr)
        local enable = self.enabled

        if not self._applied then
            local ft = vim.bo[bufnr].filetype
            local ft_enabled = self.filetypes[ft]
            if ft_enabled ~= nil then
                enable = ft_enabled
            end

            self._applied = true
        end

        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if client:supports_method("textDocument/semanticTokens/full") then
                vim.lsp.semantic_tokens[enable and "start" or "stop"](bufnr, client.id)
            end
        end
    end

}

return {opts=semantic_tokens}
