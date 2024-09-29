if not ngx then return end
local tonumber = tonumber
local require = require
local type = type

local t = t or require "t"
local is = t.is
local meta = require "meta"
local export = t.exporter
local api = require "t.nginx.auto.api"
-- or setmetatable({},{__call=function(self) end})
local say = require "t.nginx.auto.say"
local e = ngx.exit
--local json = require "t.format.json"
local cache = meta.cache

--204 No Content
local args = {
  bulkresult={
    DELETE={'nRemoved'},
    PUT={'nInserted','nUpserted'},
    POST={'nModified'}, -- of nMatched
  },
}

return api({
  PUT=function(data)
    local r=data

    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        bulkresult=function(r)
          if r.writeErrors then
            ngx.header['X-Errors']=#r.writeErrors
--            auto.logger(r.writeErrors)
          end
          return r.nInserted+r.nUpserted
        end,
        job=function(r) ngx.header['X-Job']=tostring(r._id); return end,
        failed=function(r) return false end, -- print job/error/call id? for debugging purposes???
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
        data=nil
      end
    else
      r=data
    end

--    if type(r)=='nil' then return e(404) end
    if r==false then return e(500) end
    if type(r)=='table' then
      if is.empty(r) then r=nil end
      if is.bulk(r) then r=tonumber(r) else r=toboolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end
    -- string is printed due to toboolean

    if toboolean(r) then say(data) end
    return e(200)
  end,
  GET=function(data)
    local r=data

    if type(r)=='nil' then return e(404) end
    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        job=function(r) ngx.header['X-Job']=tostring(r._id); return end,
        failed=function(r) return false end,
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
        data=nil
      end
    else
      r=data
    end

    if r==false then return e(500) end
    if type(r)=='table' then
      if is.empty(r) then r=nil end
      if is.bulk(r) then r=tonumber(r) else r=toboolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end

    if type(r)~='nil' then if toboolean(r) then say(data) else return e(404) end end
    return e(200)
  end,
  HEAD=function(data)
    local r=data
    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        failed=function(r) return false end,
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
        data=nil
      end
    else
      r=data
    end

    if type(r)=='nil' then return e(404) end
    if r==false then return e(500) end

    if type(r)=='table' then
      if is.empty(r) then r=nil end
      if is.bulk(r) then r=tonumber(r) else r=toboolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end
    if type(r)=='string' then r=#r>0 and r or nil end

    return toboolean(r) and e(200) or e(404)
  end,
  DELETE=function(data)
    local r=data
    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        bulkresult=function(r)
          if r.writeErrors then
            ngx.header['X-Errors']=#r.writeErrors
          end
          return r.nRemoved
        end,
        job=function(r) ngx.header['X-Job']=tostring(r._id); return true end,
        failed=function(r) return false end,
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
        data=nil
      end
    else
      r=data
    end

    if type(r)=='nil' then return e(404) end
    if r==false then return e(500) end

    if type(r)=='table' then
      if is.empty(r) then r=nil else
      if is.bulk(r) then r=tonumber(r) else r=toboolean(r) end end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end
    if r==0 then return e(404) end
  end,
  POST=function(data)
    local r=data

    if type(r)=='nil' then return e(404) end
    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        bulkresult=function(r)
          if r.writeErrors then
            ngx.header['X-Errors']=#r.writeErrors
          end
          return r.nModified
        end,
        job=function(r) ngx.header['X-Job']=tostring(r._id); return end,
        failed=function(r) return false end,
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
        data=nil
      end
    else
      r=data
    end

    if r==false then return e(500) end
    if type(r)=='table' then
      if is.empty(r) then r=nil end
      if is.bulk(r) then r=tonumber(r) else r=toboolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end
    if type(r)=='string' then r=#r>0 and r or nil end

    if r then say(data) end
    return e(200)
  end,
})