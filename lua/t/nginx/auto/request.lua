local t = t or require "t"
local is = t.is
local computed = t.computed

--[[
$content_type
application/x-www-form-urlencoded
text/plain
multipart/form-data
--]]

local ok3 = {
  POST=true,
  PUT=true,
  DELETE=true,
}
local ok2 = {
  POST=true,
  PUT=true,
}
local out = {
  GET=true,
  POST=true,
  PUT=true,
}

return computed({},{
__computed = {
  input_body = function(self) return ok3[self.method] end,
  write_body = function(self) return out[self.method] end,

  method  = function(self) return ngx.var.request_method end,
  data    = function(self)
    if not ok2[self.method] then return end
    local fmt = self.format
    return fmt and type(fmt)=='table' and is.callable(fmt.decode)
      and fmt.decode(self.body) or self.body
  end,
  format  = function(self)
    if ok2[self.method] then
      local fmt = t.format % self.body
      return fmt and t.format[fmt]
  end end,
  body    = function(self) if ok3[self.method] then
    ngx.req.read_body()
    return ngx.req.get_body_data()
  end end,
  header  = function(self) return ngx.req.get_headers(0) end,
  uriargs = function(self) return ngx.req.get_uri_args(0) end,
  mime    = function(self)
    if self.body then
      return is.json(self.body) and 'application/json' or ngx.var.content_type:match('[^;]+')
    end
  end
},
__call=function(self, ...) return setmetatable({},getmetatable(self)) end,
})