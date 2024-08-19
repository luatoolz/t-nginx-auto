use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => 10;
env_to_nginx('MONGO_HOST=localhost', 'MONGO_PORT=27018');
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: mongodb connect GET
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { return t.nginx.auto.response(tostring(toboolean(t.db.mongo))) }}
--- request
GET /t
--- error_code: 200
--- response
true
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: mongodb connect HEAD
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { return t.nginx.auto.response(toboolean(t.db.mongo)) }}
--- request
GET /t
--- error_code: 200
--- response
--- no_error_log
[warn]
[error]
[alert]
[emerg]
