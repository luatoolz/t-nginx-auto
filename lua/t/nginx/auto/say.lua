if not ngx then return end
local t=t or require "t"
local export=t.exporter
local auto = t.pkg(...)
local e = auto.exit
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
local function _say(data, __isjson)
  local r=data
  local mime = auto.mime()

  -- always objects iterator
  -- todo: writer
  if type(r)=='function' then
    local isjson = mime=='application/json'

    local b=r()
    if b then
      if isjson then ngx.print("[") end
      _say(b, isjson)
      b=r()
    else
      return e(404)
    end
    while b do
      if isjson then ngx.say(",") end
      _say(b, isjson)
      b=r()
    end
    if isjson then ngx.say("]") end
    return e(200)
  end

  if type(r)=='nil' or type(r)=='boolean' then return end
  if (type(r)=='table' or type(r)=='userdata') then r=export(r) end
  if type(r)=='table' and not getmetatable(r) then
    if mime=='text/plain' and #r>0 then r=table.concat(r, "\n") else r=json(r) end
    if __isjson then ngx.print(r); return end
  end
  if wrong[type(r)] then e(500); assert(nil, 't.nginx.auto.say: wrong type: ' .. type(r)) end
--  if type(r)=='number' then r=tostring(r) end
  if type(r)=='number' then if __isjson then ngx.print(r) else ngx.say(r) end end
  if type(r)=='string' and r~='' then
    if __isjson then ngx.print(json(r)) else ngx.say(r) end
  end
end
return function(...)
  if ok[ngx.var.request_method] and (not ngx.headers_sent) and ok[ngx.status] then
    table.map({...}, _say)
  end
end