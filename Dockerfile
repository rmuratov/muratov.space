FROM hugomods/hugo:debian-reg-git-0.161.1 AS builder

WORKDIR /src
COPY . .

RUN hugo --gc --minify --baseURL "https://muratov.space/"

FROM caddy:2-alpine
COPY --from=builder /src/public /usr/share/caddy
COPY Caddyfile /etc/caddy/Caddyfile
