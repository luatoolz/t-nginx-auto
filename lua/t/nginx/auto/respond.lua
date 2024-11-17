if not ngx then return end
local t=t or require "t"
local is = t.is
local auto = t.pkg(...)
local api, say, e = auto.api, auto.say, auto.exit

return api({
  PUT=function(data)
    local r=data

    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        bulkresult=function(x)
          if x.writeErrors then
            ngx.header['X-Errors']=#x.writeErrors
--            auto.logger(r.writeErrors)
          end
          return x.nInserted+x.nUpserted
        end,
        job=function(x) ngx.header['X-Job']=tostring(x._id); return end,
        failed=function(x) return false end, -- print job/error/call id? for debugging purposes???
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
      if is.bulk(r) then r=t.to.number(r) else r=t.to.boolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end
    -- string is printed due to t.to.boolean

    if t.to.boolean(r) then say(data) end
    return e(200)
  end,
  GET=function(data)
    local r=data

    if type(r)=='nil' then return e(404) end
    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        job=function(x) ngx.header['X-Job']=tostring(x._id); return end,
        failed=function(x) return false end,
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
        data=nil
      end
    end

    if r==false then return e(500) end
    if type(r)=='table' then
      if is.empty(r) then r=nil end
      if is.bulk(r) then r=t.to.number(r) else r=t.to.boolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end

--    if t.to.boolean(r) then say(data) else return e(404) end
    if type(r)~='nil' then if t.to.boolean(r) then say(data) else return e(404) end end
    return e(200)
  end,
  HEAD=function(data)
    local r=data
    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        failed=function(x) return false end,
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
      end
    end

    if type(r)=='nil' then return e(404) end
    if r==false then return e(500) end

    if type(r)=='table' then
      if is.empty(r) then r=nil end
      if is.bulk(r) then r=t.to.number(r) else r=t.to.boolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end
    if type(r)=='string' then r=#r>0 and r or nil end

    return t.to.boolean(r) and e(200) or e(404)
  end,
  DELETE=function(data)
    local r=data
    if type(r)=='table' and getmetatable(r) then
      local id=t.match.basename(t.type(r))
      local action={
        bulkresult=function(x)
          if x.writeErrors then
            ngx.header['X-Errors']=#x.writeErrors
          end
          return x.nRemoved
        end,
        job=function(x) ngx.header['X-Job']=tostring(x._id); return true end,
        failed=function(x) return false end,
      }
      local a=action[id]
      if is.callable(a) then
        r=a(r)
      end
    end

    if type(r)=='nil' then return e(404) end
    if r==false then return e(500) end

    if type(r)=='table' then
      if is.empty(r) then r=nil else
      if is.bulk(r) then r=t.to.number(r) else r=t.to.boolean(r) end end
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
        bulkresult=function(x)
          if x.writeErrors then
            ngx.header['X-Errors']=#x.writeErrors
          end
          return x.nModified
        end,
        job=function(x) ngx.header['X-Job']=tostring(x._id); return end,
        failed=function(x) return false end,
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
      if is.bulk(r) then r=t.to.number(r) else r=t.to.boolean(r) end
    end
    if type(r)=='number' then ngx.header['X-Count']=r end
    if type(r)=='string' then r=#r>0 and r or nil end

    if r then say(data) end
    return e(200)
  end,
})