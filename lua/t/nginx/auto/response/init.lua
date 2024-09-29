local meta=require "meta"
local is=meta.is
local req=meta.loader("t/nginx/auto/response")
return setmetatable({},{
  __index=function(self, key)
    local action=req[key]
    if is.callable(action) then return action() end
  end,
  __newindex=function(self, key, value)
    local action=req[key]
    if is.callable(action) then return action(value) end
  end,
})