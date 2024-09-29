local require = require
local ngx = ngx
local t = t or require("t")

-- GET/HEAD/DELETE url args
-- PUT/POST        url args + parsed body

local types={
  ['multipart/form-data']='multipart/form-data',
  ['application/json']='application/json',
  ['text/plain']='text/plain',
  ['application/x-www-form-urlencoded']='application/x-www-form-urlencoded'
}
local default_response_type={
  GET='application/json',
  HEAD=nil,
  DELETE=nil,
  POST='application/json',
  PUT='application/json',
}
--[[
  url args: ngx.req.get_uri_args()
  post args: ngx.req.get_post_args()
--]]

local api={
  req=function()
    local headers, err = ngx.req.get_headers(0)
    if err=="truncated" then
      return nil, "truncated"
    end
    return headers['Content-Type']
  end,
  res=function()
    local headers, err = ngx.req.get_headers(0)
    if err=="truncated" then
      return nil, "truncated"
    end
    return headers['Accept'] or default_response_type[ngx.var.request_method]
  end,
  null=function()
    return assert(nil, 'invalid key')
  end,
}

return setmetatable({},{
  __call=function(self, key) return self[key]() end,
  __index=function(self, key)
    if type(key)=='nil' then return api.req end
    if type(key)~='string' or #key<3 then return api.null end
    key=string.lower(key):sub(1,3)
    return api[key] or api.null
  end,
})
