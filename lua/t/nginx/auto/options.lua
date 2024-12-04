local t=t or require "t"
local auto = t.pkg(...)
local req = auto.request
local fields = t.fields

local options = fields{
  limit=t.to.izpositive,
  skip=t.to.izpositive,
}

return function()
  local args=req.uriargs or {}
  return options(args)
end