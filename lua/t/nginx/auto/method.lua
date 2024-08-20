local require = require
local type = type
local ngx = ngx

local meta = require "meta"
local t = t or require "t"
local is = t.is
local mmt = meta.mt

local def = t.def or {}

local response = require "t.nginx.auto.response"
local crud = require "t.nginx.auto.crud"

-- GET call without input, only get params
-- POST call with object params (json/etc)
-- PUT call with blobs mostly
-- HEAD check method exists
-- DELETE not implemented

local api = {
  POST=function(o, m) ngx.req.read_body()
    return m(o, ngx.req.get_body_data()) end,
  GET=function(o, m) return m(o) end,
  HEAD=function(o, m) return (o and m) and true or false end,
  PUT=function(o, m) ngx.req.read_body()
    return m(o, ngx.req.get_body_data()) end,
}

-- storage  == db
-- object   == object name
-- item     == object item
-- callable == callable function
-- found    == ?
-- method   == http request method

return function(storage)
  storage=storage or t.db.default()

  if not ngx.var.object then return ngx.exit(400) end
  local object = storage[ngx.var.object]
  if not object then return ngx.exit(404) end

  local mt=(mmt(object) or {})
  local method=ngx.var.method
  local callable=mt[method]
  if (not method) or (not callable) then
    callable=mt[ngx.var.id]
    if not is.callable(callable) then return crud(storage) end
    return response(method(object, callable))
  end

  if not callable then return ngx.exit(501) end
  if not is.callable(callable) then return ngx.exit(409) end

  if is.callable(mt[ngx.var.id]) then
-- TODO: -- mass action with filter
  end

  local item = object[ngx.var.id]
  if not item then return crud(storage) end
  method = api[ngx.var.request_method]
  if type(method)=='string' then method=api[method] end
  if not is.callable(method) then return ngx.exit(501) end
  return response(method(item, callable))

-- auto.args
  -- collect POST/GET vars
  -- collect plain
  -- collect json/yaml/etc
-- auto.mime
  -- auto detect response mime type
  -- encode
end
