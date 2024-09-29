local require = require
local ngx = ngx
local t = t or require("t")

return function(o, header)
  o=o or t.def
  header=header or 'X-Token'
  local token=ngx.req.get_headers()[header]
  o=o and o.auth or nil
  local ok=(o and token and #token>0) and o[token] or nil
  if not ok then
    return ngx.exit(ngx.HTTP_FORBIDDEN)
  end
end
