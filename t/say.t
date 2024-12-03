use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * 34;
no_long_string();
no_root_location();
check_accum_error_log();
no_diff();
run_tests();

__DATA__

=== TEST 1: t.nginx.auto.say ok with no status
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  t.nginx.auto.say('ok')
}}
--- request
GET /t
--- more_headers
--- response_body
ok
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: t.nginx.auto.say ok with status=200
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  ngx.status=200
  t.nginx.auto.say('ok')
}}
--- request
GET /t
--- more_headers
--- response_body

--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: t.nginx.auto.say ok with status=500
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  ngx.status=500
  t.nginx.auto.say('ok')
}}
--- request
GET /t
--- more_headers
--- response_body

--- error_code: 500
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: t.nginx.auto.say empty
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block {
  local say = t.nginx.auto.say
  say(); say(nil); say(true); say(false); say('')
}}
--- request
GET /t
--- response_body
--- error_code: 200

=== TEST 5: t.nginx.auto.say
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block { t.nginx.auto.say(
t.def.job({_id='66909d26cbade70b6b022b9a'}), 0, 1, 77, 'some', {}, t.array(), {'x','y'}, t.array({'x','y'}), t.set({'x','y'}), {x='x',y='y'},
{x=true,y=false,a=1,b=2,c=3,q="Q",w="W",o={x=true,y=false,a=1,b=2,c=3,q="Q",w="W"},t={true,false,0,1,2,3,"one","two",{x=true},{y=false},{z=77}}}
)}}
--- request
GET /t
--- response_body
{"_id":{"$oid":"66909d26cbade70b6b022b9a"}}
0
1
77
some
[]
[]
["x","y"]
["x","y"]
["x","y"]
{"x":"x","y":"y"}
{"a":1,"b":2,"c":3,"o":{"a":1,"b":2,"c":3,"q":"Q","w":"W","x":true,"y":false},"q":"Q","t":[true,false,0,1,2,3,"one","two",{"x":true},{"y":false},{"z":77}],"w":"W","x":true,"y":false}
--- error_code: 200

=== TEST 6: t.nginx.auto.say o % id
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block {
  local say = t.nginx.auto.say
  say(t.def.data/'66909d26cbade70b6b022b9a')
}}
--- request
GET /t
--- response_body
{"_id":{"$oid":"66909d26cbade70b6b022b9a"}}
--- error_code: 200

=== TEST 7: t.nginx.auto.say({...})
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block {
  local say = t.nginx.auto.say
  say({'a','b','c'})
}}
--- request
GET /t
--- more_headers
Accept: text/plain
--- response_body
a
b
c
--- error_code: 200

=== TEST 8: t.nginx.auto.say(it)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block {
  local say = t.nginx.auto.say
  local resp = t.nginx.auto.response
  say(resp.mime, table.iter({{'a'},{'b'},{'c'}}))
}}
--- request
GET /t
--- more_headers
Accept: text/plain
--- response_body
text/plain
a
b
c
--- error_code: 200

=== TEST 9: t.nginx.auto.say(it)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block {
  local say = t.nginx.auto.say
  say(table.iter({{m='a'},{m='b'},{m='c'}}))
}}
--- request
GET /t
--- more_headers
Accept: application/json
--- response_body
[{"m":"a"},
{"m":"b"},
{"m":"c"}]
--- error_code: 200

=== TEST 10: t.nginx.auto.say(it)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block {
  local say = t.nginx.auto.say
  say(table.iter({'a','b','c'}))
}}
--- request
GET /t
--- more_headers
Accept: application/json
--- response_body
["a",
"b",
"c"]
--- error_code: 200

=== TEST 11: t.nginx.auto.say(it)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
location = /t { content_by_lua_block {
  local say = t.nginx.auto.say
  say(table.iter({111,222,333}))
}}
--- request
GET /t
--- more_headers
Accept: application/json
--- response_body
[111,
222,
333]
--- error_code: 200
