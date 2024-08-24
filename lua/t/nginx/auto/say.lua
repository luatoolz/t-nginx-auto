local t = t or require "t"
local json = t.format.json
local say=ngx and ngx.say or print

local function _say(r)
  if type(r)=='nil' or type(r)=='boolean' then return end
  if type(r)=='number' then r=tostring(r) end
  if type(r)=='table' or type(r)=='userdata' then r=json(r) end
  if type(r)=='string' and r~='' then say(r) end
end

return function(...) return table({...}) * _say end
