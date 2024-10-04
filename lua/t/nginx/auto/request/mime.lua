if not ngx then return end
local t=t or require "t"
local is=t.is
local req=t.pkg(...)

--[[
$content_type
application/x-www-form-urlencoded
text/plain
multipart/form-data
--]]

local set = {
  POST=true,
  PUT=true,
  DELETE=true,
}

return function()
  if set[ngx.var.request_method] and req.body then
    if is.json(req.body) then return 'application/json' end
    return ngx.var.content_type:match('[^;]+')
  end
end