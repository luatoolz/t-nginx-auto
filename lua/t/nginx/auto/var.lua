local ngx = ngx or {var={}}
local t=t or require "t"
local types={
  id=t.match.id,
  object=t.match.id,
  method=t.match.id,
}
return setmetatable({},{
__index=function(self, k)
  local to=types[k]
  k=ngx.var[k]
  if to then return to(k) end
  return k
end,
})