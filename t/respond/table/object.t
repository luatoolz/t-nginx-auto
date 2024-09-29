use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 6;
no_long_string();
no_root_location();
check_accum_error_log();
no_diff();
run_tests();

__DATA__

=== TEST 1: t.nginx.auto.respond GET table object
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { t.nginx.auto.respond({x="x"}) }}
--- request
GET /t
--- more_headers
--- response_body
{"x":"x"}
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: t.nginx.auto.respond HEAD table object
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { t.nginx.auto.respond({x="x"}) }}
--- request
HEAD /t
--- more_headers
--- response_body
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: t.nginx.auto.respond DELETE table object
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { t.nginx.auto.respond({x="x"}) }}
--- request
DELETE /t
--- more_headers
--- response_body
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: t.nginx.auto.respond PUT table object
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { t.nginx.auto.respond({x="x"}) }}
--- request
PUT /t
--- more_headers
--- response_body
{"x":"x"}
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

