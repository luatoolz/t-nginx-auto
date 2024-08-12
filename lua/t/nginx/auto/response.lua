local tonumber = tonumber
local require = require
local type = type
local ngx = ngx

local t = require "t"
local is = t.is
local json = t.format.json

local api = {
  GET=function(r)
    if type(r) == 'nil' then return ngx.exit(404) end
    if type(r) == 'boolean' then return ngx.exit(r and 200 or 404) end
    if type(r) == 'number' then
      ngx.say(tostring(r));
      return ngx.exit(200)
    end
    if type(r) == 'string' then
      if r ~= '' then ngx.say(r) end
      return ngx.exit(200)
    end
    if type(r) == 'table' then
      if (not is.array(r)) and getmetatable(r) and type(getmetatable(r).__tostring)=='function' then r=tostring(r) else r=json.encode(r) end
      ngx.say(r)
      return ngx.exit(200)
    end
    return ngx.exit(500)
  end,
  HEAD=function(r)
    if type(r) == 'nil' then
      ngx.header['X-Count'] = 0
      return ngx.exit(404)
    end
    if type(r) == 'table' then
      if is.bulk(r) then
        r = tonumber(r) or #r
      else
        r = toboolean(r)
      end
    end
    if type(r) == 'boolean' then return ngx.exit(r and 200 or 404) end
    if type(r) == 'number' then
      ngx.header['X-Count'] = r
      return ngx.exit(r>0 and 200 or 404)
    end
    if type(r) == 'string' then return ngx.exit(#r > 0 and 200 or 404) end
    return ngx.exit(500)
  end,
  DELETE=function(r) return ngx.exit(toboolean(r) and 200 or 500) end,
  POST='PUT',
  PUT=function(r)
    if type(r) == 'table' and is.bulk(r) then ngx.header['X-Count']=tonumber(r) end
    if type(r) == 'number' then ngx.header['X-Count']=r; return ngx.exit(200) end
    return ngx.exit(toboolean(r) and 200 or 500)
  end,
}

return function(r)
  local method = api[ngx.var.request_method]
  if type(method) == 'string' then method = api[method] end
  if not is.callable(method) then return ngx.exit(501) end
  return method and method(r) or nil
end
