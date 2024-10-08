use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 6;
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: t.nginx.auto.request.mime GET set
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
GET /t
--- more_headers
Content-Type: application/json
--- error_code: 200
--- response_body
nil
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: t.nginx.auto.request.mime GET
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
GET /t
--- more_headers
--- error_code: 200
--- response_headers
--- response_body
nil
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: t.nginx.auto.request.mime DELETE
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
DELETE /t
--- more_headers
Content-Type: application/json
--- error_code: 200
--- response_headers
--- response_body
nil
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: t.nginx.auto.request.mime DELETE
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
DELETE /t
{"x":"q"}
--- more_headers
Content-Type: application/json
--- error_code: 200
--- response_headers
--- response_body
application/json
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: t.nginx.auto.request.mime PUT
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
PUT /t
x=y
--- more_headers
Content-Type: application/x-www-form-urlencoded
--- error_code: 200
--- response_headers
--- response_body
application/x-www-form-urlencoded
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 6: t.nginx.auto.request.mime POST
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
POST /t
--- more_headers
--- error_code: 200
--- response_headers
--- response_body
nil
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 7: t.nginx.auto.request.mime POST json
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
POST /t
{"a":"a"}
--- more_headers
--- error_code: 200
--- response_headers
--- response_body
application/json
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 8: t.nginx.auto.request.mime POST json array
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.say(t.nginx.auto.request.mime) }}
--- request
POST /t
[{"token":"95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7","role":"root"},
{"token":"46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a","role":"traffer"},
{"token":"60879afb54028243bb82726a5485819a8bbcacd1df738439bfdf06bc3ea628d0","role":"panel"}]
--- more_headers
--- error_code: 200
--- response_headers
--- response_body
application/json
--- no_error_log
[warn]
[error]
[alert]
[emerg]
