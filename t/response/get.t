use strict;
use warnings;
use Test::Nginx::Socket::Lua;

plan tests => repeat_each() * blocks() * 2;
run_tests();

__DATA__

=== TEST 1: response(true)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(true) }}
--- request
GET /t
--- response_body

=== TEST 2: response(false)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 /404;
location = /404 { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(false) }}
--- request
GET /t
--- response_body
--- error_code: 404

=== TEST 3: response(4)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(4) }}
--- request
GET /t
--- response_body
4
--- error_code: 200

=== TEST 4: response(nil)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
error_page 403 404 /404;
location = /404 { internal; return 200 ""; }
location /t { content_by_lua_block { return t.nginx.auto.response(nil) }}
--- request
GET /t
--- response_body

--- error_code: 404

=== TEST 5: response(empty string)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response('') }}
--- request
GET /t
--- response_body

=== TEST 6: response(some string)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response('some') }}
--- request
GET /t
--- response_body
some

=== TEST 7: response(array)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(t.array({1,2,3,4})) }}
--- request
GET /t
--- response_body
[1,2,3,4]

=== TEST 8: response(table array)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response({1,2,3,4}) }}
--- request
GET /t
--- response_body
[1,2,3,4]

=== TEST 9: response(empty array)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response(t.array()) }}
--- request
GET /t
--- response_body
[]

=== TEST 10: response(empty table array)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response({}) }}
--- request
GET /t
--- response_body
[]

=== TEST 11: response(object)
--- http_config
lua_package_path "../../../lua/?.lua;../../../lua/?/init.lua;;";
init_by_lua_block { t = require "t" }
--- config
location /t { content_by_lua_block { return t.nginx.auto.response({a="AA", b="BB", c={"x", "y", "z"}}) }}
--- request
GET /t
--- response_body
{"a":"AA","b":"BB","c":["x","y","z"]}
