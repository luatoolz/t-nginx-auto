local t=t or require "t"
local auto = t.pkg(...)
local req = auto.request

return function(o, header)
  o=o or t.def
  header=header or 'X-Token'
  local token=req.header[header]
  o=o and o.auth or nil
  local ok=(o and token and #token>0) and o[token] or nil
  if not ok then
    return ngx.exit(ngx.HTTP_FORBIDDEN)
  end
end