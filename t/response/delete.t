use strict;
use warnings;
use Test::Nginx::Socket::Lua;

plan tests => repeat_each() * blocks() * 2;
run_tests();

__DATA__

=== TEST 1: response.DELETE(true)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t {
add_header Allow "GET, DELETE, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response(true) }}
--- request
DELETE /t
--- error_code: 200
--- response_body

=== TEST 2: response.DELETE(false)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, DELETE, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response(false) }}
--- request
DELETE /t
--- response_body
--- error_code: 500

=== TEST 3: response.DELETE(4)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(4) }}
--- request
DELETE /t
--- response_body
--- error_code: 200

=== TEST 4: response.DELETE(nil)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(nil) }}
--- request
DELETE /t
--- response_body
--- error_code: 500

=== TEST 5: response.DELETE(empty string)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, DELETE, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response('') }}
--- request
DELETE /t
--- response_body
--- error_code: 500

=== TEST 6: response.DELETE(some string)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response('some') }}
--- request
DELETE /t
--- response_body
--- error_code: 200

=== TEST 7: response.DELETE(array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(t.array({1,2,3,4})) }}
--- request
DELETE /t
--- response_body
--- error_code: 200

=== TEST 8: response.DELETE(table array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response({1,2,3,4}) }}
--- request
DELETE /t
--- response_body
--- error_code: 200

=== TEST 9: response.DELETE(empty array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, DELETE, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response(t.array()) }}
--- request
DELETE /t
--- response_body
--- error_code: 500

=== TEST 10: response.DELETE(empty table array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, DELETE, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response({}) }}
--- request
DELETE /t
--- response_body
--- error_code: 500

=== TEST 11: response.DELETE(object)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response({a="AA", b="BB", c={"x", "y", "z"}}) }}
--- request
DELETE /t
--- response_body
--- error_code: 200
