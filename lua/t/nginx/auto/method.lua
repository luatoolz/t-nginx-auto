local require = require
local type = type
local ngx = ngx

local meta = require "meta"
local t = t or require "t"
local is = t.is
local mmt = meta.mt

local response = require "t.nginx.auto.response"
local crud = require "t.nginx.auto.crud"
local log = require "t.nginx.auto.log"
local _ = log

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

return function(storage, def)
--  storage=storage or t.db.default()
  assert(storage, 'dead storage')
  assert(def, 'dead def')

  if not ngx.var.object then return ngx.exit(400) end
  local object = assert(def[ngx.var.object], 'def object')
  if not object then return ngx.exit(404) end

  local mt=mmt(object)
  local method=ngx.var.method
  local callable=mt[method]

  if (not method) or (not callable) then
    method = ngx.var.id
    callable=callable or mt[method]

    if not is.callable(callable) then return crud(storage) end
    local http_method = api[ngx.var.request_method]
    if type(http_method)=='string' then http_method=api[http_method] end
    if not is.callable(http_method) then return ngx.exit(501) end
    return response(http_method(object, callable))
  end
  if not callable then return ngx.exit(501) end
  if not is.callable(callable) then return ngx.exit(409) end

  if is.callable(mt[ngx.var.id]) then
-- TODO: -- mass action with filter
  end

  local item = object[ngx.var.id]
  if not item then return crud(storage) end
  local http_method = api[ngx.var.request_method]
  if type(http_method)=='string' then http_method=api[http_method] end
  if not is.callable(http_method) then return ngx.exit(501) end
  return response(http_method(item, callable))

-- auto.args
  -- collect POST/GET vars
  -- collect plain
  -- collect json/yaml/etc
-- auto.mime
  -- auto detect response mime type
  -- encode
end
