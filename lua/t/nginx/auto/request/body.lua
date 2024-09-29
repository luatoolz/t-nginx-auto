if not ngx then return end
local ok={
  PUT=true,
  POST=true,
  DELETE=true,
}
return function()
  if not ok[ngx.var.request_method] then return nil end
  ngx.req.read_body()
  return ngx.req.get_body_data()
end
