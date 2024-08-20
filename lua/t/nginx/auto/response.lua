local tonumber = tonumber
local require = require
local type = type
local ngx = ngx

local t = require "t"
local is = t.is
local json = t.format.json

local say

-- possible object types:
-- job
-- object (def)
-- records
-- function iterators?
-- t.array / t.set / bulk
-- table/userdata + mt ?
-- native lua types?

local api = {
  GET=function(r)
    if type(r)=='nil' then r=false end
    if type(r)=='table' then say(json(r)); r=toboolean(r) end
    if type(r)=='number' then say(tostring(r)); r=true end
    if type(r)=='string' then if r~='' then say(r) end; r=true end
    if type(r)=='boolean' then return ngx.exit(r and 200 or 404) end
    return ngx.exit(500)
  end,
  HEAD=function(r)
    if type(r)=='nil' then r=false end
    if type(r)=='table' then r=(is.bulk(r) or is.tonumber(r)) and (tonumber(r) or #r) or toboolean(r) end
    if type(r)=='string' then r=(r~='') end
    if type(r)=='number' then ngx.header['X-Count']=r; r=r>0 end
    if type(r)=='boolean' then return ngx.exit(r and 200 or 404) end
    return ngx.exit(500)
  end,
  DELETE=function(r) return ngx.exit(toboolean(r) and 200 or 500) end,
  POST='PUT',
  PUT=function(r)
    if type(r)=='table' then r=tonumber(r) or 0; end
    if type(r)=='number' then ngx.header['X-Count']=r; r=true end
    if type(r)~='boolean' then r=toboolean(r) end
    return ngx.exit(r and 200 or 500)
  end,
}

return function(r)
  say=say or ngx.say
  local method=api[ngx.var.request_method]
  if type(method)=='string' then method=api[method] end
  if not is.callable(method) then return ngx.exit(501) end
-- if JOB - create X-Job header
  return method(r)
end
