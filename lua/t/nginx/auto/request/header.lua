if not ngx then return end
return function() return ngx.req.get_headers(0) end