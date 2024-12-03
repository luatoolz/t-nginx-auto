use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each()*blocks()*6+2;
env_to_nginx('MONGO_HOST=localhost', 'MONGO_PORT=27018');
no_shuffle();
#no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: DELETE /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.method() }}
--- request
DELETE /t/noneexistent
--- response_body
--- error_code: 200
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: HEAD /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { return t.nginx.auto.method() }}}
--- request
HEAD /t/noneexistent
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: PUT /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.method() }}
--- request
PUT /t/noneexistent
--- response_body
--- error_code: 400
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: PUT /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.method() }}
--- request
PUT /t/noneexistent
{}
--- response_body
--- error_code: 200
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: HEAD /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { return t.nginx.auto.method() }}}
--- request
HEAD /t/noneexistent
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

=== TEST 6: POST /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.method() }}
--- request
POST /t/noneexistent
--- response_body
--- error_code: 400
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 7: DELETE /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.method() }}
--- request
DELETE /t/noneexistent
--- response_body
--- error_code: 200
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 8: HEAD /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { return t.nginx.auto.method() }}}
--- request
HEAD /t/noneexistent
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 0
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 9: GET /t/noneexistent
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 400 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.method() }}
--- request
GET /t/noneexistent
--- response_body
--- error_code: 404
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]
