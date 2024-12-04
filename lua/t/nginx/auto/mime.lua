local t=t or require "t"
local auto = t.pkg(...)
local resp = auto.response
local ok = {
	['application/json']='application/json',
	['text/plain']='text/plain',
}
local default = 'application/json'
return function(set)
	local mime = ok[resp.mime]
	if mime and mime~=default and set then
		ngx.header['Content-type']=mime
	end
	return mime or default
end