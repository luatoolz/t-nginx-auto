if not ngx then return end
local t=t or require "t"
local req=t.pkg(...)
local ok = {
  POST=true,
  PUT=true,
}
return function()
  if not ok[ngx.var.request_method] then return end
  local fmt = t.format % req.body
  return fmt and t.format[fmt]
end