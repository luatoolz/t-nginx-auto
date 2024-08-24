local tonumber = tonumber
local require = require
local type = type
local ngx = ngx

local t = require "t"
local is = t.is

local say = require "t.nginx.auto.say"

-- possible object types:
-- job
-- object (def)
-- records
-- function iterators?
-- t.array / t.set / bulk
-- table/userdata + mt ?
-- native lua types?

local _response = function(data, status)
  if data and data~='' and status==200 then say(data) end
  return ngx.exit(status)
end

local api = {
  GET=function(r)
    local data=r
    if type(r)=='nil' then r=false end
    if type(r)=='table' then r=true end --toboolean(r) end
    if type(r)=='number' then r=true end
    if type(r)=='string' then r=true end
--    if type(r)=='boolean' then return ngx.exit(r and 200 or 404) end
    return _response(data, type(r)=='boolean' and (r and 200 or 404) or 500)
  end,
  HEAD=function(r)
    if type(r)=='nil' then r=false end
    if type(r)=='table' then r=(is.bulk(r) or is.tonumber(r)) and (tonumber(r) or #r) or toboolean(r) end
    if type(r)=='string' then r=(r~='') end
    if type(r)=='number' then ngx.header['X-Count']=r; r=r>0 end
    if type(r)~='boolean' then r=toboolean(r) end
    return _response(nil, type(r)=='boolean' and (r and 200 or 404) or 500)
  end,
  DELETE=function(r) return ngx.exit(toboolean(r) and 200 or 500) end,
  POST='PUT',
  PUT=function(r)
    if type(r)=='table' then r=tonumber(r) or 0; end
    if type(r)=='number' then ngx.header['X-Count']=r; r=true end
    if type(r)~='boolean' then r=toboolean(r) end
    return _response(nil, r and 200 or 500)
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
