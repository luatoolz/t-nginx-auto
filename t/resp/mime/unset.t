use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 6;
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: t.nginx.auto.response.mime GET unset
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.header['X-Result']=t.nginx.auto.response.mime }}
--- request
GET /t
--- more_headers
--- error_code: 200
--- response_headers
X-Result:
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: t.nginx.auto.response.mime HEAD unset
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.header['X-Result']=t.nginx.auto.response.mime }}
--- request
HEAD /t
--- more_headers
Accept: application/json
--- error_code: 200
--- response_headers
X-Result:
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: t.nginx.auto.response.mime DELETE unset
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.header['X-Result']=t.nginx.auto.response.mime }}
--- request
DELETE /t
--- more_headers
Accept: application/json
--- error_code: 200
--- response_headers
X-Result:
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: t.nginx.auto.response.mime PUT unset
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.header['X-Result']=t.nginx.auto.response.mime }}
--- request
PUT /t
--- more_headers
--- error_code: 200
--- response_headers
X-Result:
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: t.nginx.auto.response.mime POST unset
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { ngx.header['X-Result']=t.nginx.auto.response.mime }}
--- request
POST /t
--- more_headers
--- error_code: 200
--- response_headers
X-Result:
--- no_error_log
[warn]
[error]
[alert]
[emerg]
