local require = require
local type = type
local ngx = ngx

local t = t or require "t"
local is = t.is
local req=require "t.nginx.auto.request"
local respond = require "t.nginx.auto.respond"
local api = require "t.nginx.auto.api"

local to = setmetatable({['']={}},{
__index=function(self, k) return rawget(self, k) or k end, })

local method = api({
  POST='PUT', -- TODO: edit object
  GET=function(o) return o[to[ngx.var.id]] end,
  HEAD=function(o) return o % to[ngx.var.id] end,
  DELETE=function(o) return o-to[ngx.var.id] end,
  PUT=function(o) return o + req.data end,
})

return function(def)
  local o=(def or t.def)[ngx.var.object] or ngx.exit(404)
  return respond(method(o))
end