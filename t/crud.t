use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
#plan tests => repeat_each()*blocks() * 5;
plan tests => 56;
env_to_nginx('MONGO_HOST=localhost', 'MONGO_PORT=27018');
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: mongodb connect
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t { content_by_lua_block { return t.nginx.auto.response(tostring(toboolean(t.storage.mongo()))) }}
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

=== TEST 2: DELETE
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}
--- request
DELETE /t/data/*
--- response_body
--- timeout: 5s
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: PUT one
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}
--- request
PUT /t/data
{"_id":"66909d26cbade70b6b022b9a","x":"one"}
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: HEAD one
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}}
--- request
HEAD /t/data/66909d26cbade70b6b022b9a
--- response_body
--- timeout: 5s
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: HEAD *
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}}
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

=== TEST 6: PUT another
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}
--- request
PUT /t/data
{"x":"second"}
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 7: HEAD * 2
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 2
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 8: PUT bulk
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}
--- request
PUT /t/data
[{"x":"2"},{"x":"3"},{"x":"4"},{"x":"5"},{"x":"6"}]
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 9: HEAD * 3
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "mongo"; require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
content_by_lua_block { return t.nginx.auto.crud(t.storage.mongo()) }}}
--- request
HEAD /t/data
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 7
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]
