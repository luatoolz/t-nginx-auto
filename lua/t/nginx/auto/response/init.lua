local t=t or require "t"
local is=t.is
local res=t.pkg(...)
return setmetatable({},{
  __index=function(self, key)
    local action=res[key]
    if is.callable(action) then return action() end
  end,
  __newindex=function(self, key, value)
    local action=res[key]
    if is.callable(action) then return action(value) end
  end,
})