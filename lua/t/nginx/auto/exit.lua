if not ngx then return end
return setmetatable({
code = {
  [100] = "continue",
  [101] = "switching_protocols",
  [200] = "ok",
  [201] = "created",
  [202] = "accepted",
  [204] = "no_content",
  [206] = "partial_content",
  [300] = "special_response",
  [301] = "moved_permanently",
  [302] = "moved_temporarily",
  [303] = "see_other",
  [304] = "not_modified",
  [307] = "temporary_redirect",
  [308] = "permanent_redirect",
  [400] = "bad_request",
  [401] = "unauthorized",
  [402] = "payment_required",
  [403] = "forbidden",
  [404] = "not_found",
  [405] = "not_allowed",
  [406] = "not_acceptable",
  [408] = "request_timeout",
  [409] = "conflict",
  [410] = "gone",
  [426] = "upgrade_required",
  [429] = "too_many_requests",
  [444] = "close",
  [451] = "illegal",
  [500] = "internal_server_error",
  [501] = "not_implemented",
  [502] = "bad_gateway",
  [503] = "service_unavailable",
  [504] = "gateway_timeout",
  [505] = "version_not_supported",
  [507] = "insufficient_storage",
},
err = {
  continue              = 100,
  switching_protocols   = 101,
  ok                    = 200,
  created               = 201,
  accepted              = 202,
  no_content            = 204,
  partial_content       = 206,
  special_response      = 300,
  moved_permanently     = 301,
  moved_temporarily     = 302,
  see_other             = 303,
  not_modified          = 304,
  temporary_redirect    = 307,
  permanent_redirect    = 308,
  bad_request           = 400,
  unauthorized          = 401,
  payment_required      = 402,
  forbidden             = 403,
  not_found             = 404,
  not_allowed           = 405,
  not_acceptable        = 406,
  request_timeout       = 408,
  conflict              = 409,
  gone                  = 410,
  upgrade_required      = 426,
  too_many_requests     = 429,
  close                 = 444,
  illegal               = 451,
  internal_server_error = 500,
  not_implemented       = 501,
  bad_gateway           = 502,
  service_unavailable   = 503,
  gateway_timeout       = 504,
  version_not_supported = 505,
  insufficient_storage  = 507,
}},{
  __call=function(self, c) return self[c] end,
  __index=function(self, c)
    return ngx.exit(self.err[self.code[c]] or
           self.err[c] or
           ngx['HTTP_' .. tostring(c):upper()] or
           ngx.status)
  end,
})