FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html favicon.svg robots.txt /usr/share/nginx/html/
COPY .well-known /usr/share/nginx/html/.well-known

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO /dev/null http://127.0.0.1/ || exit 1
