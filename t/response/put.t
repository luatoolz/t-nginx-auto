use strict;
use warnings;
use Test::Nginx::Socket::Lua;

plan tests => repeat_each() * blocks() * 2;
run_tests();

__DATA__

=== TEST 1: response.PUT(true)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t {
add_header Allow "GET, PUT, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response(true) }}
--- request
PUT /t
--- error_code: 200
--- response_body

=== TEST 2: response.PUT(false)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response(false) }}
--- request
PUT /t
--- response_body
--- error_code: 500

=== TEST 3: response.PUT(4)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(4) }}
--- request
PUT /t
--- response_body
--- error_code: 200

=== TEST 4: response.PUT(nil)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(nil) }}
--- request
PUT /t
--- response_body
--- error_code: 500

=== TEST 5: response.PUT(empty string)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response('') }}
--- request
PUT /t
--- response_body
--- error_code: 500

=== TEST 6: response.PUT(some string)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response('some') }}
--- request
PUT /t
--- response_body
--- error_code: 200

=== TEST 7: response.PUT(array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(t.array({1,2,3,4})) }}
--- request
PUT /t
--- response_body
--- error_code: 200

=== TEST 8: response.PUT(table array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response({1,2,3,4}) }}
--- request
PUT /t
--- response_body
--- error_code: 200

=== TEST 9: response.PUT(empty array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response(t.array()) }}
--- request
PUT /t
--- response_body
--- error_code: 200

=== TEST 10: response.PUT(empty table array)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, HEAD, PUT, POST" always;
content_by_lua_block { return t.nginx.auto.response({}) }}
--- request
PUT /t
--- response_body
--- error_code: 200

=== TEST 11: response.PUT(object)
--- http_config
lua_package_path "../../lua/?.lua;../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response({a="AA", b="BB", c={"x", "y", "z"}}) }}
--- request
PUT /t
--- response_body
--- error_code: 200
