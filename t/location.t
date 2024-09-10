use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => repeat_each() * blocks() * 2;
no_shuffle();
no_long_string();
no_root_location();
check_accum_error_log();
run_tests();

__DATA__

=== TEST 1: /t/o
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t"; join=('/'):joiner() }
--- config
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { ngx.say(join(ngx.var.id, ngx.var.object, ngx.var.method)) }}
--- request
GET /t/o
--- response_body
o

=== TEST 2: /t/o/
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t"; join=('/'):joiner() }
--- config
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { ngx.say(join(ngx.var.id, ngx.var.object, ngx.var.method)) }}
--- request
GET /t/o/
--- response_body
o

=== TEST 3: /t/o/id
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t"; join=('/'):joiner() }
--- config
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { ngx.say(join(ngx.var.id, ngx.var.object, ngx.var.method)) }}
--- request
GET /t/o/id
--- response_body
id/o

=== TEST 4: /t/o/id/
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t"; join=('/'):joiner() }
--- config
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { ngx.say(join(ngx.var.id, ngx.var.object, ngx.var.method)) }}
--- request
GET /t/o/id/
--- response_body
id/o

=== TEST 5: /t/o/id/meth
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t"; join=('/'):joiner() }
--- config
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { ngx.say(join(ngx.var.id, ngx.var.object, ngx.var.method)) }}
--- request
GET /t/o/id/meth
--- response_body
id/o/meth

=== TEST 6: /t/o/id/meth/
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t"; join=('/'):joiner() }
--- config
location ~* ^/t/(?<object>[^\/]+)((/(?<id>[^\/]+))(/(?<method>[^\/]+))?)?/?$ {
content_by_lua_block { ngx.say(join(ngx.var.id, ngx.var.object, ngx.var.method)) }}
--- request
GET /t/o/id/meth/
--- response_body
id/o/meth
