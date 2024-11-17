local ngx = ngx or {var={}}
local t=t or require "t"
local types={
  id=t.match.uripart,
  object=t.match.uripart,
  method=t.match.uripart,
}
return setmetatable({},{
__index=function(self, k)
  local to=types[k]
  k=ngx.var[k]
  if to then return to(k) end
  return k
end,
})