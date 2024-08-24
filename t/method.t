use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 6;
env_to_nginx('MONGO_HOST=localhost', 'MONGO_PORT=27018');
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: HEAD existing method
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;../?.lua;../?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { local td=require('meta').loader('testdata'); return t.nginx.auto.method(td.db, td.def) }}}
--- request
HEAD /t/remote/ping
--- error_code: 200
--- timeout: 5s
--- response_body
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: HEAD nonexisting method
--- http_config
lua_package_path "../lua/?.lua;../lua/?/init.lua;../?.lua;../?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location /t { add_header Allow "GET, PUT, POST, HEAD, DELETE" always;
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { local td=require('meta').loader('testdata'); return t.nginx.auto.method(td.db, td.def) }}}
--- request
HEAD /t/remote/noneexistent
--- error_code: 404
--- timeout: 5s
--- response_body
--- no_error_log
[warn]
[error]
[alert]
[emerg]
