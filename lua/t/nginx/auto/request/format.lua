if not ngx then return end
local t=t or require "t"
local req=t.pkg(...)
local ok = {
  POST=true,
  PUT=true,
}
return function()
  if not ok[ngx.var.request_method] then return end
  local body = req.body
  if not body then return end
  local fmt = t.format % body
  if fmt then return t.format[fmt] end
end