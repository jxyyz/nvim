local augroup = require("lib.lsp._utils").augroup

local inlay_hints = {
    enabled = false,
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

            self:_init()
            self._applied = true
        end

        vim.lsp.inlay_hint.enable(enable, {bufnr=bufnr})
    end

}

function inlay_hints:_init(bufnr)
    local instance = self

    vim.api.nvim_create_autocmd("InsertEnter", {
        group = augroup,
        buffer = bufnr,
        callback = function() 
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) 
        end,
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = augroup,
        buffer = bufnr,
        callback = function() vim.lsp.inlay_hint.enable(instance.enabled, { bufnr = bufnr }) end,
    })
end

return {opts=inlay_hints}
