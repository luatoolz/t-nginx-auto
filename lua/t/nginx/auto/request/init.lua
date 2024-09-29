local meta=require "meta"
local is=meta.is
local no=meta.no
local req=meta.loader("t/nginx/auto/request")
return setmetatable({},{
  __index=function(self, key)
    local action=req[key]
    if is.callable(action) then return no.call(action) end
  end,
})