local meta=require "meta"
local unpack = unpack or table.unpack
return ngx and (meta.log ^ function(...) return ((select('#', ...) or 0)>0 and ngx) and ngx.log(ngx.WARN, unpack(table(...) * tostring)) or nil end)