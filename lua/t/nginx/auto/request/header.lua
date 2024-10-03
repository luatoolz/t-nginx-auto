if not ngx then return end
return function() return assert(ngx.req.get_headers(0)) or {} end