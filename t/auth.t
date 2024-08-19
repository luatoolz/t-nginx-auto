use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => 39;
env_to_nginx('MONGO_HOST=localhost', 'MONGO_PORT=27018');
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: PUT auth
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud(t.db.mongo) }}
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

=== TEST 2: auth ok
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.nginx.auto.auth(t.db.mongo) }
  content_by_lua_block { return t.nginx.auto.response('ok') }
}
--- request
GET /t
--- more_headers
X-Token: 95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7
--- error_code: 200
--- response
ok
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: auth fail wrong token
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.nginx.auto.auth(t.db.mongo) }
  content_by_lua_block { return t.nginx.auto.response('ok') }
}
--- request
GET /t
--- more_headers
X-Token: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
--- error_code: 403
--- response
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: auth fail empty token
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.nginx.auto.auth(t.db.mongo) }
  content_by_lua_block { return t.nginx.auto.response('ok') }
}
--- request
GET /t
--- more_headers
X-Token:
--- error_code: 403
--- response
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: auth fail no token
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.nginx.auto.auth(t.db.mongo) }
  content_by_lua_block { return t.nginx.auto.response('ok') }
}
--- request
GET /t
--- error_code: 403
--- response
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: DELETE auth
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud(t.db.mongo) }}
--- request
DELETE /t/auth
--- response_body
--- error_code: 200
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 6: HEAD auth
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location ~* ^/t/(?<object>[^\/]+)(/(?<id>[^\/]+))?/?$ {
add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
content_by_lua_block { return t.nginx.auto.crud(t.db.mongo) }}
--- request
HEAD /t/auth
--- response_body
--- response_headers
X-Count: 0
--- error_code: 404
--- timeout: 5s
--- no_error_log
[warn]
[error]
[alert]
[emerg]
