return setmetatable({},{
  __action={
    default=function(self) return true end,
    ping=function(self) return true end,
  }
})