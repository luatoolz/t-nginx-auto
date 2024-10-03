if not ngx then return end
local t=t or require "t"
local auto = t.pkg(...)

local req, respond, api, var, e =
  auto.request, auto.respond, auto.api, auto.var, auto.exit

local method = api({
  GET=function(o) return o[var.id or {}] end,
  HEAD=function(o) return o % (var.id or {}) end,
  DELETE=function(o) return o-(var.id or {}) end,
  PUT=function(o)
    if not req.data or (var.id and not o/var.id) then return e(400) end
    return o + req.data end, -- with valid id, with invalid id
  POST='PUT',
--  POST=function(o) if not req.data then return e(400) end; return o + req.data end, -- with valid id, with invalid id
})

return function(def, noresp)
  local o=(def or t.def)[var.object] or e(404)
  if var.id and (not (o/var.id)) then return e(400) end
  if noresp then return method(o) end
  return respond(method(o))
end