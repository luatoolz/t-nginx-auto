use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 2;
no_root_location();
run_tests();

__DATA__

=== TEST 1: is.http_request_methods OK
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { ngx.say(t.is.http_request_methods({PUT=true,POST=true})) }}
--- request
GET /t
--- error_code: 200
--- response_body
true
