-- return mime only if explicit Accept: header presents
-- default: decide later in t.nginx.auto.respond()
if not ngx then return end
local t=t or require "t"
local req=t.pkg('t.nginx.auto').request()
return function()
  local header=req.header
  return req.write_body and header['Accept'] or nil
end