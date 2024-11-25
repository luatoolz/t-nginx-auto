if not ngx then return end
local t=t or require "t"
local export=t.exporter
local json = t.format.json
local wrong={
  ['table']=true,
  ['userdata']=true,
  ['thread']=true,
  ['CFunction']=true,
  ['function']=true,
}
local ok = {
  [0]=true,
  ['000']=true,
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
  if type(r)=='string' and r~='' then ngx.say(r) end
end
return function(...)
  if ok[ngx.var.request_method] and (not ngx.headers_sent) and ok[ngx.status] then
    for i=1,select('#', ...) do _say(select(i, ...)) end
  end
end