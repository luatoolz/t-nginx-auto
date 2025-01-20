if not ngx then return end
local t=t or require "t"
return function(to) if type(to)~='nil' then ngx.status=to end; return ngx.var.status end