FROM debian:oldstable

ARG CERTS_
ARG CERTS_KEY
ARG WORDPRESS_URL

RUN apt update -y && apt upgrade && apt install -y nginx openssl gettext-base

RUN openssl req -batch -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout $CERTS_KEY -out $CERTS_

RUN rm -f /etc/nginx/sites-enabled/default

COPY ./conf/default.template /etc/nginx/conf.d/

RUN envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
