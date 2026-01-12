local req = function(s) require("core."..s) end
req("set")
req("remap")
req("ftdetect")
req("autocmds")
req("lazy")
