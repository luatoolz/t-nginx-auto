local require = require
local type = type
local ngx = ngx

local t = require "t"
local is = t.is

local api = {
  POST='PUT',
  GET = function(o) return o[ngx.var.id] end,
  HEAD = function(o) return o % ngx.var.id end,
  DELETE = function(o) return o-ngx.var.id end,
  PUT = function(o) return o+ngx.req.get_body_data() end,
}

return function(r)
	local method = api[ngx.var.request_method]
	if type(method)=='string' then method=api[method] end
	if not is.callable(method) then return ngx.exit(500) end
  assert(type(r)=='table' and type(getmetatable(r))=='table', ('t.nginx.auto.method: invalid argument: await %s, got %s'):format('object', type(r)))
	return method(r)
end
