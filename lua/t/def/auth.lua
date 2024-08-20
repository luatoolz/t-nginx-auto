local t = t or require "t"
assert(t)

return {
  token=t.string,
  role=t.string,
  [true] = {
    id=[[token]],
    required=[[token role]],
  }
}