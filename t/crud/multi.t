use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => 127;
env_to_nginx('MONGO_HOST=127.0.0.1', 'MONGO_PORT=27018');
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: HEAD auth
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
HEAD /t/auth/95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7
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

=== TEST 2: PUT bulk auth
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
[{"token":"95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7","role":"root"},{"token":"46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a","role":"traffer"},{"token":"60879afb54028243bb82726a5485819a8bbcacd1df738439bfdf06bc3ea628d0","role":"panel"}]
--- response_body
--- error_code: 200
--- timeout: 5s
--- response_headers
X-Count: 3
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: HEAD auth
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

=== TEST 4: HEAD /t/auth/46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a
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

=== TEST 5: HEAD auth filter root
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
HEAD /t/auth/root
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

=== TEST 6: HEAD auth filter traffer
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
HEAD /t/auth/root
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

=== TEST 7: DELETE auth
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
DELETE /t/auth/46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 8: HEAD auth
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
X-Count: 2
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 9: HEAD auth filter traffer
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
HEAD /t/auth/traffer
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

=== TEST 10: DELETE auth bulk
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
["95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7",
"60879afb54028243bb82726a5485819a8bbcacd1df738439bfdf06bc3ea628d0"]
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 11: HEAD auth
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
X-Count: 0
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 12: PUT bulk add auth 2
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
[{"_id":"66ef5a258aa5f11c0c094b25","token":"95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7","role":"root"},
{"_id":"66ef5a258aa5f11c0c094b26","token":"46db395df332f18b437d572837d314e421804aaed0f229872ce7d8825d11ff9a","role":"traffer"},
{"_id":"66ef5a258aa5f11c0c094b27","token":"60879afb54028243bb82726a5485819a8bbcacd1df738439bfdf06bc3ea628d0","role":"panel"},
{"_id":"66ef5a258aa5f11c0c094b28","token":"e150a1ec81e8e93e1eae2c3a77e66ec6dbd6a3b460f89c1d08aecf422ee401a0","role":"root"}]
--- response_body
--- error_code: 200
--- timeout: 5s
--- response_headers
X-Count: 4
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 13: HEAD auth filter root
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
HEAD /t/auth/root
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

=== TEST 14: GET auth filter root
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
GET /t/auth/root
--- response_body
[{"_id":{"$oid":"66ef5a258aa5f11c0c094b25"},"role":"root","token":"95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7"},
{"_id":{"$oid":"66ef5a258aa5f11c0c094b28"},"role":"root","token":"e150a1ec81e8e93e1eae2c3a77e66ec6dbd6a3b460f89c1d08aecf422ee401a0"}]
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 15: DELETE auth filter root
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
DELETE /t/auth/root
--- response_body
--- timeout: 5s
--- response_headers
--- error_code: 200
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 16: HEAD auth filter root
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
HEAD /t/auth/root
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

=== TEST 17: HEAD auth filter traffer
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
HEAD /t/auth/traffer
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

=== TEST 18: DELETE auth
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

=== TEST 19: HEAD auth
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
X-Count: 0
--- error_code: 404
--- no_error_log
[warn]
[error]
[alert]
[emerg]
