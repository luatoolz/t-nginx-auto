local t=t or require "t"
local is=t.is
local auto=t.pkg(...)

local req, respond, api, var, e, crud =
  auto.request, auto.respond, auto.api, auto.var, auto.exit, auto.crud

--local e = ngx.exit
--local req=require "t.nginx.auto.request"
--local respond = require "t.nginx.auto.respond"
--local crud = require "t.nginx.auto.crud"
--local api = require "t.nginx.auto.api"
--local var = require "t.nginx.auto.var"

local method = api({
  POST=function(o, m) return m(o, req.data) end,
  GET=function(o, m) return m(o) end,
  HEAD=function(o, m) return (o and m) and true or false end,
  PUT=function(o, m) return m(o, req.data) end,
  DELETE=function(o, m) return e(501) end,
})

return function(def)
  def=def or t.def
  local object, id, m = var.object, var.id, var.method
  local o = object and def[object] or e(404)

  if id and m then
    local found = o[id]
    if is.array(found) then
      -- ...
    end
    if is.defitem(found) then
      local f = o.__action[m]
      if is.callable(f) then
        return respond(method(found, f))
      end
    end
    return e(501)
  end
  m=m or id
  if m then
    local f = o.__action[m]
    if is.callable(f) then
      return respond(method(o, f))
    end
  else
    m='__'
    if is.callable(o.__action[m]) then
      return respond(method(o, o.__action[m]))
    end
  end
  return crud(def)
end