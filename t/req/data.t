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

=== TEST 1: t.nginx.auto.request.data POST json object
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  local data = t.nginx.auto.request.data
  ngx.header['X-Count']=type(data)=='table' and #data or nil
  ngx.say(tostring(data or 'nil')) }}
--- request
POST /t
{"a":"a"}
--- more_headers
X-Count: 1
--- response_body_like
^table\: .*$
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: t.nginx.auto.request.data POST empty
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  local data = t.nginx.auto.request.data
  ngx.header['X-Count']=type(data)=='table' and #data or nil
  ngx.say(tostring(data or 'nil')) }}
--- request
POST /t
--- more_headers
--- response_body
nil
--- error_code: 200
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]
