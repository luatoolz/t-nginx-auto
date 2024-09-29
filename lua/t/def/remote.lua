local t = t or require "t"
local job = t.def.job

return setmetatable({
  type=t.string,
  id=t.string,
  host=t.string,
  userid=t.number,
  _='id',
  [true]='id host',
}, {
  ping=function(self) return 'pong' end,
  login=function(self)
    local rv = job({_id='66dfe09dea1d5a24f00c0f82',pass=self.pass})
    return rv
  end,
  __computed={
    session=function(self) end,
    company=function(self) end,
  },
})