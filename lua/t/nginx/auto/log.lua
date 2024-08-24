require "meta"
local inspect = require 'inspect'
local unpack = unpack or table.unpack

return function(...)
  local msg = table(...) * inspect
  ngx.log(ngx.ERR, unpack(msg))
end
