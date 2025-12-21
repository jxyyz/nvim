local req = function(s) require("core."..s) end
req("set")
req("remap")
req("autocmds")
req("lazy")
