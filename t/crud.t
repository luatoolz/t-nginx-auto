use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => 130;
env_to_nginx('MONGO_HOST=localhost', 'MONGO_PORT=27018');
no_shuffle();
#no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: PUT any to /t/data
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
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: DELETE /t/data/*
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
DELETE /t/data/*
--- response_body
--- timeout: 5s
--- error_code: 200
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
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: PUT any2 to /t/data
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
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: DELETE /t/data
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

=== TEST 6: HEAD /t/data
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
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 7: PUT one
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
{"_id":"66909d26cbade70b6b022b9a","x":"one"}
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 8: HEAD one
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
HEAD /t/data/66909d26cbade70b6b022b9a
--- response_body
--- timeout: 5s
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 9: GET one *
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
GET /t/data
--- response_body
[{"_id":"66909d26cbade70b6b022b9a","x":"one"}]
--- timeout: 5s
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 10: HEAD *
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

=== TEST 11: PUT second
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
{"x":"second"}
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 12: HEAD * 2
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
X-Count: 2
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 13: PUT bulk
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
[{"x":"2"},{"x":"3"},{"x":"4"},{"x":"5"},{"x":"6"}]
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 14: HEAD * 3
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
X-Count: 7
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 15: DELETE /t/data (clear)
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
DELETE /t/data
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 16: DELETE /t/auth
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
DELETE /t/auth
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 17: PUT bulk auth
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
PUT /t/auth
[{"token":"95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7","role":"root"},
{"token":"46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a","role":"traffer"},
{"token":"60879afb54028243bb82726a5485819a8bbcacd1df738439bfdf06bc3ea628d0","role":"panel"}]
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 18: HEAD auth
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
HEAD /t/auth
--- response_body
--- timeout: 5s
--- response_headers
X-Count: 3
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 19: HEAD /t/auth/46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a
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
HEAD /t/auth/46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 20: DELETE auth
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
DELETE /t/auth
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 21: HEAD auth
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
HEAD /t/auth
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]
