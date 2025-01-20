local t=t or require "t"
local auto = t.pkg(...)
local req = auto.request()
local lazy=false

return function(o, header)
  if type(o)=='boolean' then
    lazy=o
    return
  end
  o=o or t.def
  header=header or 'X-Token'
  local token=req.header[header]
  token=token~='' and token or nil
  o=o and o.auth or nil
  local ok=(o and ((lazy and (o%{})==0) or o[token])) and true or nil
  if not ok then
    return ngx.exit(ngx.HTTP_FORBIDDEN)
  end
end