use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 7;
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: t.nginx.auto.api POST
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
    GET=function() ngx.header['X-Method']=ngx.var.request_method; return ngx.var.request_method end,
    POST='GET',
    PUT='GET',
    DELETE=function() ngx.header['X-Method']=ngx.var.request_method end,
    HEAD='DELETE'
  })
  ngx.say(api())
}}
--- request
POST /t
--- more_headers
--- response_body
POST
--- error_code: 200
--- response_headers
X-Method: POST
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: t.nginx.auto.api GET
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
    GET=function() ngx.header['X-Method']=ngx.var.request_method; return ngx.var.request_method end,
    POST='GET',
    PUT='GET',
    DELETE=function() ngx.header['X-Method']=ngx.var.request_method end,
    HEAD='DELETE'
  })
  ngx.say(api())
}}
--- request
GET /t
--- more_headers
--- response_body
GET
--- error_code: 200
--- response_headers
X-Method: GET
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: t.nginx.auto.api PUT
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
    GET=function() ngx.header['X-Method']=ngx.var.request_method; return ngx.var.request_method end,
    POST='GET',
    PUT='GET',
    DELETE=function() ngx.header['X-Method']=ngx.var.request_method end,
    HEAD='DELETE'
  })
  ngx.say(api())
}}
--- request
PUT /t
--- more_headers
--- response_body
PUT
--- error_code: 200
--- response_headers
X-Method: PUT
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: t.nginx.auto.api HEAD
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
    GET=function() ngx.header['X-Method']=ngx.var.request_method; return ngx.var.request_method end,
    POST='GET',
    PUT='GET',
    DELETE=function() ngx.header['X-Method']=ngx.var.request_method end,
    HEAD='DELETE'
  })
  ngx.say(api())
}}
--- request
HEAD /t
--- more_headers
--- response_body
--- error_code: 200
--- response_headers
X-Method: HEAD
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: t.nginx.auto.api DELETE
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
    GET=function() ngx.header['X-Method']=ngx.var.request_method; return ngx.var.request_method end,
    POST='GET',
    PUT='GET',
    DELETE=function() ngx.header['X-Method']=ngx.var.request_method end,
    HEAD='DELETE'
  })
  api()
}}
--- request
DELETE /t
--- more_headers
--- response_body
--- error_code: 200
--- response_headers
X-Method: DELETE
--- no_error_log
[warn]
[error]
[alert]
[emerg]
