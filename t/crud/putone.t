use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each()*blocks()*6 + 3;
env_to_nginx('MONGO_HOST=localhost', 'MONGO_PORT=27018');
no_shuffle();
#no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: HEAD /t/data before
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { return t.nginx.auto.crud() }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 0
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]


=== TEST 2: PUT any to /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud() }}
--- request
PUT /t/data
{"x":"any"}
--- response_body
--- error_code: 200
--- timeout: 5s
--- response_headers
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: HEAD /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { return t.nginx.auto.crud() }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 1
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]


=== TEST 4: DELETE /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud() }}
--- request
DELETE /t/data
--- response_body
--- timeout: 5s
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: HEAD /t/data
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { return t.nginx.auto.crud() }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 0
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]

