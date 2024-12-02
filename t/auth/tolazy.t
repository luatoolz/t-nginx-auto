use strict;
use warnings;
use Test::Nginx::Socket::Lua;

repeat_each(1);
plan tests => 66;
env_to_nginx('MONGO_HOST=127.0.0.1', 'MONGO_PORT=27018');
no_shuffle();
no_root_location();
check_accum_error_log();
run_tests();
log_level('debug');

__DATA__

=== TEST 1: strict auth notoken fail
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block {
    t.def.auth[{}]=nil
    t.nginx.auto.auth()
  }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- error_code: 403
--- response_body

--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 2: strict auth empty token fail
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.def.auth[{}]=nil; t.nginx.auto.auth() }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- more_headers
X-Token:
--- error_code: 403
--- response_body

--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 3: strict auth with token fail
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.def.auth[{}]=nil; t.nginx.auto.auth() }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- more_headers
X-Token: 95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7
--- error_code: 403
--- response_body
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 4: lazy auth notoken nodb ok
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.def.auth[{}]=nil; t.nginx.auto.auth(true); t.nginx.auto.auth() }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- error_code: 200
--- response_body
ok
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 5: lazy auth with empty token nodb ok
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.def.auth[{}]=nil; t.nginx.auto.auth(true); t.nginx.auto.auth() }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- more_headers
X-Token:
--- error_code: 200
--- response_body
ok
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 6: lazy auth with correct token nodb ok
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.def.auth[{}]=nil; t.nginx.auto.auth(true); t.nginx.auto.auth() }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- more_headers
X-Token: 95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7
--- error_code: 200
--- response_body
ok
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 7: lazy auth with incorrect token nodb ok
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block { t.def.auth[{}]=nil; t.nginx.auto.auth(true); t.nginx.auto.auth() }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- more_headers
X-Token: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
--- error_code: 200
--- response_body
ok
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 8: lazy auth notoken db fail
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block {
    _ = t.def.auth + {token="95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7",role="root"}
    t.nginx.auto.auth(true)
    t.nginx.auto.auth()
  }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- error_code: 403
--- response_body

--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 9: lazy auth with correct token db ok
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block {
    t.nginx.auto.auth(true)
    t.nginx.auto.auth()
  }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- more_headers
X-Token: 95687c9a1a88dd2d552438573dd018748dfff0222c76f085515be2dc1db2afa7
--- error_code: 200
--- response_body
ok
--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 10: lazy auth with incorrect token db fail
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block {
    t.nginx.auto.auth(true)
    t.nginx.auto.auth()
  }
  content_by_lua_block { return t.nginx.auto.respond('ok') }
}
--- request
GET /t
--- more_headers
X-Token: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
--- error_code: 403
--- response_body

--- no_error_log
[warn]
[error]
[alert]
[emerg]

=== TEST 11: lazy auth with empty token db fail
--- http_config
lua_package_path "lua/?.lua;lua/?/init.lua;?.lua;?/init.lua;;";
init_by_lua_block { require "t" }
--- config
error_page 403 404 405 500 501 @error;
location @error { internal; return 200 ""; }
location = /t {
  access_by_lua_block {
    t.nginx.auto.auth(true)
    t.nginx.auto.auth()
  }
  content_by_lua_block {
    t.def.auth[{}]=nil
    return t.nginx.auto.respond('ok')
  }
}
--- request
GET /t
--- more_headers
X-Token:
--- error_code: 403
--- response_body

--- no_error_log
[warn]
[error]
[alert]
[emerg]
