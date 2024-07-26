# syntax=docker/dockerfile:1

FROM ubuntu AS builder1

ARG LUA_VERSION=5.1

RUN apt update -y && apt install -y \
  ca-certificates curl \
  build-essential make git cmake \
  nginx libnginx-mod-http-lua \
  lua${LUA_VERSION} \
  luarocks \
  cpanminus

FROM builder1 AS builder2

RUN cpanm Test::Nginx::Socket::Lua https://github.com/luatoolz/App-Prove-Plugin-NginxModules.git
RUN luarocks config --scope system lua_dir /usr

FROM builder2 AS soft

RUN luarocks install --deps-mode all --only-deps --dev t-nginx-auto
RUN luarocks install --dev t-nginx-auto

FROM scratch
COPY --from=soft / /
