local t=t or require "t"
local auto = t.pkg(...)
local req = auto.request
local options = t.def.options

return function()
  local args=req.uriargs or {}
  return options(args)
end