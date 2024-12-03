use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each()*blocks()*6 + 3;
env_to_nginx('MONGO_HOST=127.0.0.1', 'MONGO_PORT=27018');
no_shuffle();
#no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: HEAD /t/data before
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { ngx.header['X-Count']=t.nginx.auto.crud(nil, true) }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 0
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: PUT empty to /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { t.nginx.auto.say(t.nginx.auto.crud(nil, true)) }}
--- request
PUT /t/data
--- response_body
--- error_code: 400
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: PUT any to /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { t.nginx.auto.say(tostring(t.nginx.auto.crud(nil, true))) }}
--- request
PUT /t/data
{"_id":"66909d26cbade70b6b022b9a","x":"any"}
--- response_body
true
--- error_code: 200
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: GET raw /t/data/66909d26cbade70b6b022b9a
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { local var=t.nginx.auto.var; return t.nginx.auto.say(t.def[var.object][var.id]) }}
--- request
GET /t/data/66909d26cbade70b6b022b9a
--- response_body
{"_id":{"$oid":"66909d26cbade70b6b022b9a"},"x":"any"}
--- error_code: 200
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: GET /t/data/66909d26cbade70b6b022b9a
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { t.nginx.auto.say(t.nginx.auto.crud(nil, true)) }}}
--- request
GET /t/data/66909d26cbade70b6b022b9a
--- response_body
{"_id":{"$oid":"66909d26cbade70b6b022b9a"},"x":"any"}
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 6: GET /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { t.nginx.auto.say(t.array(t.nginx.auto.crud(nil, true))) }}}
--- request
GET /t/data
--- response_body
[{"_id":{"$oid":"66909d26cbade70b6b022b9a"},"x":"any"}]
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 7: GET /t/data toboolean
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block {
  local v=t.nginx.auto.crud(nil, true)
  t.nginx.auto.say(t.exporter(v), t.type(v), t.match.basename(t.type(v)), tostring(t.to.boolean(v)))
}}}
--- request
GET /t/data/66909d26cbade70b6b022b9a
--- response_body
{"_id":{"$oid":"66909d26cbade70b6b022b9a"},"x":"any"}
t/def data
data
true
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 8: HEAD /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { ngx.header['X-Count']=t.nginx.auto.crud(nil, true) }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 1
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 9: DELETE /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(tostring(t.nginx.auto.crud(nil, true))) }}
--- request
DELETE /t/data
--- response_body
true
--- timeout: 5s
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 10: HEAD /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { ngx.header['X-Count']=t.nginx.auto.crud(nil, true) }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 0
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 11: GET /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { t.nginx.auto.say(t.nginx.auto.crud(nil, true)) }}}
--- request
GET /t/data
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 12: GET /t/data toboolean
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block {
  local v=t.nginx.auto.crud(nil, true)
  if type(v)=='function' then v=t.array(v) end
  t.nginx.auto.say(t.exporter(v), t.type(v), t.match.basename(t.type(v)), tostring(t.to.boolean(v)))
}}}
--- request
GET /t/data
--- response_body
[]
array
array
false
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]
