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

=== TEST 1: t.nginx.auto.response.status
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  local api = t.nginx.auto.api({
    GET=function(o) return o or t.nginx.auto.response.status end,
    POST='GET',
    PUT='GET',
  })
  ngx.say(api())
}}
--- request
POST /t
--- more_headers
--- response_body
0
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: t.nginx.auto.response.status set 200
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  local api = t.nginx.auto.api({
    GET=function(o) return o or t.nginx.auto.response.status end,
    POST='GET',
    PUT='GET',
  })
  t.nginx.auto.response.status=200
  ngx.say(api())
}}
--- request
POST /t
--- more_headers
--- response_body
200
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: t.nginx.auto.response.status set 500
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  local api = t.nginx.auto.api({
    GET=function(o) return o or t.nginx.auto.response.status end,
    POST='GET',
    PUT='GET',
  })
  t.nginx.auto.response.status=500
  ngx.say(api())
}}
--- request
POST /t
--- more_headers
--- response_body
500
--- error_code: 500
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: t.nginx.auto.response.status x2
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  local api = t.nginx.auto.api({
    GET=function(o) return o or t.nginx.auto.response.status end,
    POST='GET',
    PUT='GET',
  })
  ngx.say(api())
  ngx.say(api())
}}
--- request
POST /t
--- more_headers
--- response_body
0
200
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]
