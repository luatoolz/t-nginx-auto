local require = require
local type = type
local ngx = ngx

local t = t or require "t"
local is = t.is

local response = require "t.nginx.auto.response"

local api = {
  POST='PUT', -- TODO: edit object
  GET=function(o) return o[ngx.var.id] end,
  HEAD=function(o) return o % ngx.var.id end,
  DELETE=function(o) return -o[ngx.var.id] end,
  PUT=function(o) ngx.req.read_body(); return o + ngx.req.get_body_data() end,
}

return function(o)
  o=o or t.db.default()
  assert(o.__objects)
  local method = api[ngx.var.request_method]
  if type(method) == 'string' then method = api[method] end
  if not is.callable(method) then return ngx.exit(501) end
  o=o and o[ngx.var.object] or nil
  return o and response(method(o)) or ngx.exit(500)
end
