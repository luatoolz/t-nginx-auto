local ok=setmetatable({
  POST=true,
  GET=true,
  HEAD=true,
  DELETE=true,
  PUT=true,
},{
__call=function(self, k)
  return self[k]
end,
__index=function(self, key)
  return false
end,
})
return function(o)
  if type(o)~='table' or type(next(o))=='nil' then return false end
  for k,_ in pairs(o) do
    if not ok[k] then return false end
  end
  return true
end