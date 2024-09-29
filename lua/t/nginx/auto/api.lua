if not ngx then return end
local t=t or require "t"
local is=t.is
local api={}
return setmetatable(api,{
  __call=function(self, ...)
    local len=select('#', ...)
    local o=len>0 and select(1, ...) or {}
    if api==self then return setmetatable(o, getmetatable(self)) end
    if not is.http_request_methods(self) then return ngx.exit(501) end
      local method = self[ngx.var.request_method]
      if type(method) == 'string' then method = self[method] end
      if not is.callable(method) then return ngx.exit(501) end
      return method(...)
  end,
})