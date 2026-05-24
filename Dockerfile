FROM hugomods/hugo:ext-0.114.0 AS builder

WORKDIR /src
COPY . .

RUN hugo --gc --minify --baseURL "https://muratov.space/"

FROM caddy:2-alpine
COPY --from=builder /src/public /usr/share/caddy
COPY Caddyfile /etc/caddy/Caddyfile
