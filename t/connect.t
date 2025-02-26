use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 6;
env_to_nginx('MONGO_HOST=127.0.0.1', 'MONGO_PORT=27018');
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: mongodb connect GET
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { return t.nginx.auto.respond(t.to.boolean(t.storage.mongo)) }}
--- request
GET /t
--- error_code: 200
--- response_body
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: mongodb connect HEAD
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { return t.nginx.auto.respond(t.to.boolean(t.storage.mongo)) }}
--- request
HEAD /t
--- error_code: 200
--- response_body
--- no_error_log
[warn]
[error]
[alert]
[emerg]
