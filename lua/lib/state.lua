local M = {}

---@class StateRegistry
---@field get fun(key?: any): table|nil
---@field set fun(key: any, value: table)
---@field remove fun(key: any)
---@field exists fun(key: any): boolean
---@field keys fun(): any[]
---@field each fun(fn: fun(key: any, state: table))
---@field clear fun()
---@field feature fun(name: string, methods: table): table
---@field [string] any

---@class StateOpts
---@field default_key? fun(): any
---@field init? fun(key: any): table

---Create a new state registry
---@param opts? StateOpts
---@return StateRegistry
function M.create(opts)
    opts = opts or {}

    local store = {}

    local registry = {}

    function registry.get(key)
        key = key or (opts.default_key and opts.default_key())
        if key == nil then return nil end

        if not store[key] then
            store[key] = opts.init and opts.init(key) or {}
        end
        return store[key]
    end

    function registry.set(key, value)
        store[key] = value
    end

    function registry.remove(key)
        store[key] = nil
    end

    function registry.exists(key)
        return store[key] ~= nil
    end

    function registry.keys()
        return vim.tbl_keys(store)
    end

    function registry.each(fn)
        for key, state in pairs(store) do
            fn(key, state)
        end
    end

    function registry.clear()
        store = {}
    end

    --- Create a feature group with scoped methods
    --- Methods receive (state, feature_state, key) as arguments
    ---@param feature_name string
    ---@param methods table<string, fun(state: table, feature: table, key: any)>
    -- function registry.feature(feature_name, methods)
    --     local feature = {}
    --     for name, fn in pairs(methods) do
    --         feature[name] = function(key)
    --             key = key or (opts.default_key and opts.default_key())
    --             local state = registry.get(key)
    --             return fn(state, state[feature_name], key)
    --         end
    --     end
    --     return feature
    -- end

    return setmetatable(registry, {
        __newindex = function (t, name, definition)
            -- Check if normal field
            --
            -- If table register as feature
            --
            -- If function transform into method
            --
            -- If field save as field
        end
    })
end

-- Presets

M.buffer = function(init)
    local reg = M.create({
        default_key = vim.api.nvim_get_current_buf,
        init = init,
    })

    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        callback = function(args) reg.remove(args.buf) end,
    })

    return reg
end

M.window = function(init)
    local reg = M.create({
        default_key = vim.api.nvim_get_current_win,
        init = init,
    })
    
    vim.api.nvim_create_autocmd("WinClosed", {
        callback = function(args) reg.remove(tonumber(args.match)) end,
    })
    
    return reg
end

M.tab = function(init)
    local reg = M.create({
        default_key = vim.api.nvim_get_current_tabpage,
        init = init,
    })
    
    vim.api.nvim_create_autocmd("TabClosed", {
        callback = function(args) reg.remove(tonumber(args.match)) end,
    })
    
    return reg
end

M.filetype = function(init)
    return M.create({
        default_key = function() return vim.bo.filetype end,
        init = init,
    })
end

M.project = function(init)
    return M.create({
        default_key = function()
            return vim.fs.root(0, { ".git", "Makefile", "Cargo.toml", "go.mod", "package.json" })
                or vim.fn.getcwd()
        end,
        init = init,
    })
end

M.lsp_client = function(init)
    local reg = M.create({
        default_key = function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            return clients[1] and clients[1].id
        end,
        init = init,
    })
    
    vim.api.nvim_create_autocmd("LspDetach", {
        callback = function(args)
            if args.data and args.data.client_id then
                reg.remove(args.data.client_id)
            end
        end,
    })
    
    return reg
end

return M
