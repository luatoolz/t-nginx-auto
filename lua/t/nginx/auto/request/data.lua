if not ngx then return end
local t=t or require "t"
local is=t.is
local req=t.pkg(...)
local ok = {
  POST=true,
  PUT=true,
}
return function()
  if not ok[ngx.var.request_method] then return end
  local fmt = req.format
  return fmt and type(fmt)=='table' and is.callable(fmt.decode)
    and fmt.decode(req.body) or req.body
--  if not fmt then return req.body end
--  if type(fmt)=='table' and is.callable(fmt.decode) then return fmt.decode(req.body) end
--  assert(type(fmt.decode)=='function', 'no fmt.decode')
--  if fmt then return fmt.decode(req.body) or req.body end
end