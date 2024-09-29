use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 2;
no_root_location();
run_tests();

__DATA__

=== TEST 1: is.http_request_methods nil
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods(nil)) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 2: is.http_request_methods nil empty
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods()) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 3: is.http_request_methods boolean
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods(true)) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 4: is.http_request_methods number
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods(0)) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 5: is.http_request_methods empty string
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods('')) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 6: is.http_request_methods some string
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods('some')) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 7: is.http_request_methods empty table
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods({})) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 8: is.http_request_methods wrong bulk table
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods({true})) }}
--- request
GET /t
--- error_code: 200
--- response_body
false

=== TEST 9: is.http_request_methods wrong object table
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods({some=true})) }}
--- request
GET /t
--- error_code: 200
--- response_body
false
