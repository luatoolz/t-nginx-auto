if not ngx then return end
local t=t or require "t"
local is=t.is
local req=require "t.nginx.auto.request"
local default = 'application/x-www-form-urlencoded'
local ok = {
  POST=true,
  PUT=true,
}
return function()
  local header=req.header
  if not ok[ngx.var.request_method] then return default end
  return header['Content-Type'] or (is.json(req.body) and 'application/json') or default
end