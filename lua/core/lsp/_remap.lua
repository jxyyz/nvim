local M = {}


function M:init(opts)
    local bufnr, client = opts.bufnr, opts.client

    local function map_all(mappings)
        for _, m in ipairs(mappings) do
            vim.keymap.set(m[1], m[2], m[3], {
                buffer = bufnr, noremap = true, silent = true, desc = m[4]
            })
        end
    end

    local function map_if(method, fn, mappings)
        if client:supports_method(method) then
            for _, m in ipairs(mappings) do
                vim.keymap.set(m[1], m[2], fn, {
                    buffer = bufnr, noremap = true, silent = true, desc = m[3]
                })
            end
        end
    end

    return {map_all = map_all, map_if = map_if}
end


return M
