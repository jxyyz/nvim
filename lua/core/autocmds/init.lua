local req = function(s) require("core.autocmds."..s) end

req("folds")
req("general")
req("onstart")
