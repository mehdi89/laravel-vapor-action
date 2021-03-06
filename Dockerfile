FROM composer:1.9.3

LABEL repository="https://github.com/ubient/laravel-vapor-action"
LABEL homepage="https://github.com/ubient/laravel-vapor-action"
LABEL maintainer="Claudio Dekker <claudio@ubient.net>"

# Install required extenstions for laravel
# https://laravel.com/docs/6.x#server-requirements
RUN apk add oniguruma-dev libxml2-dev && \
    docker-php-ext-install bcmath xml tokenizer mbstring
    
RUN apk add --update --no-cache libpng-dev; \
    docker-php-ext-install gd

# Install Vapor + Prestissimo (parallel/quicker composer install)
RUN set -xe && \
    composer global require hirak/prestissimo && \
    composer global require laravel/vapor-cli && \
    composer clear-cache

# Install Node.js (needed for Vapor's NPM Build)
RUN apk add --update nodejs npm

# Prepare out Entrypoint (used to run Vapor commands)
COPY vapor-entrypoint /usr/local/bin/vapor-entrypoint

ENTRYPOINT ["/usr/local/bin/vapor-entrypoint"]
