use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
env_to_nginx('MONGO_HOST=127.0.0.1', 'MONGO_PORT=27018');
plan tests => repeat_each()*blocks()*6;
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: GET /t
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block {
  local auto=t.nginx.auto
  local say, options=auto.say, auto.options
  return say(options()) 
}}
--- request
GET /t?limit=1&skip=7
--- response_body
{"limit":1,"skip":7}
--- error_code: 200
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]
