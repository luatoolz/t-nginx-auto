local t = t
local td
return (function()
  t = t or require('t')
  td = td or require('meta').loader('testdata')
  return t.storage.mongo ^ td.def
end)()