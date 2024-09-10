use strict;
use warnings;
use Test::Nginx::Socket::Lua;

plan tests => repeat_each() * blocks() * 2 + 3;
run_tests();

__DATA__

=== TEST 1: response.HEAD(true)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(true) }}
--- request
HEAD /t
--- response_body

=== TEST 2: response.HEAD(false)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(false) }}
--- request
HEAD /t
--- response_body
--- error_code: 404

=== TEST 3: response.HEAD(4)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(4) }}
--- request
HEAD /t
--- response_body
--- response_headers
X-Count: 4
--- error_code: 200

=== TEST 4: response.HEAD(nil)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(nil) }}
--- request
HEAD /t
--- response_body
--- error_code: 404

=== TEST 5: response.HEAD(empty string)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response('') }}
--- request
HEAD /t
--- response_body
--- error_code: 404

=== TEST 6: response.HEAD(some string)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response('some') }}
--- request
HEAD /t
--- response_body

=== TEST 7: response.HEAD(array)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(t.array({1,2,3,4})) }}
--- request
HEAD /t
--- response_body
--- response_headers
X-Count: 4

=== TEST 8: response.HEAD(table array)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response({1,2,3,4}) }}
--- request
HEAD /t
--- response_body
--- response_headers
X-Count: 4

=== TEST 9: response.HEAD(empty array)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(t.array()) }}
--- request
HEAD /t
--- response_body
--- error_code: 404

=== TEST 10: response.HEAD(empty table array)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response({}) }}
--- request
HEAD /t
--- response_body
--- error_code: 404

=== TEST 11: response.HEAD(object)
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response({a="AA", b="BB", c={"x", "y", "z"}}) }}
--- request
HEAD /t
--- response_body
--- error_code: 200
