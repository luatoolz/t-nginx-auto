local require = require
local ngx = ngx
local t = t or require "t"

return function(o, header)
  header=header or 'X-Token'
  local token=ngx.req.get_headers()[header]
  o=o and o.auth or nil
  local ok=o and token and #token>0 and o[token]
  if not ok then
    return ngx.exit(ngx.HTTP_FORBIDDEN)
  end
end
