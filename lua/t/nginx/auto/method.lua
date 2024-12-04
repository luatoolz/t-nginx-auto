local t=t or require "t"
local is=t.is
local auto=t.pkg(...)

local req, respond, api, var, e, crud =
  auto.request, auto.respond, auto.api, auto.var, auto.exit, auto.crud

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
    local f = o.__action[m]
    -- TODO: operate iterators
    if is.bulk(found) then
      if is.callable(f) then
        return respond(found * function(it) return method(it, f) end)
      end
    end
    if is.defitem(found) then
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
    local f = o.__action.default
    if is.callable(f) then
      return respond(method(o, f))
    end
  end
  return crud(def)
end