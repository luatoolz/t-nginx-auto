local t = t or require "t"
local export=t.exporter
local json = t.format.json
local say=ngx and ngx.say or print
local wrong={
  ['table']=true,
  ['userdata']=true,
  ['thread']=true,
  ['CFunction']=true,
  ['function']=true,
}
local okstatus = {
  [0]=true,
--  [200]=true,
}
local ok = {
  GET=true,
  PUT=true,
  POST=true,
}
local function _say(data)
  local r=data
  if type(r)=='nil' or type(r)=='boolean' then return end
  if (type(r)=='table' or type(r)=='userdata') then r=export(r) end
  if type(r)=='table' and not getmetatable(r) then r=json(r) end
  if wrong[type(r)] then ngx.exit(500); assert(nil, 't.nginx.auto.say: wrong type: ' .. type(r)) end
  if type(r)=='number' then r=tostring(r) end
  if type(r)=='string' and r~='' then say(r) end
end
return function(...)
  if ok[ngx.var.request_method] and okstatus[ngx.status] then
    for i=1,select('#', ...) do _say(select(i, ...)) end
  end
end