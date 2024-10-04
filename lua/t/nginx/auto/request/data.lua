if not ngx then return end
local t=t or require "t"
local req=t.pkg(...)
local ok = {
  POST=true,
  PUT=true,
}
return function()
  if not ok[ngx.var.request_method] then return end
  local fmt = req.format
  assert(type(fmt.decode)=='function', 'no fmt.decode')
  if fmt then return fmt.decode(req.body) or req.body end
end