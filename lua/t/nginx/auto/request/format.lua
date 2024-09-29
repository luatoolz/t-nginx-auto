if not ngx then return end
local t=t or require "t"
local is=t.is
local req=require "t.nginx.auto.request"
local ok = {
  POST=true,
  PUT=true,
}
return function()
  if not ok[ngx.var.request_method] then return end
  local fmt = t.format % req.body
  if fmt then return t.format[fmt] end
end