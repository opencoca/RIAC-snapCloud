FROM ubuntu:20.04

LABEL MAINTAINER="Startr LLC Labs and Robot in a Can"
LABEL version="1.0"
LABEL description="Snap! Cloud"

# Non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y lua5.1 liblua5.1-0-dev
RUN apt-get install -y libssl1.1

# Install dependencies for LuaRocks and OpenSSL
RUN apt-get update && \
    apt-get install -y wget build-essential unzip libreadline-dev libncurses5-dev libssl-dev lua5.1 luarocks


# Upgrade LuaRocks
RUN wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz && \
    tar zxpf luarocks-3.9.2.tar.gz && \
    cd luarocks-3.9.2 && \
    ./configure --lua-version=5.1 --versioned-rocks-dir && \
    make && make install && \
    cd .. && rm -rf luarocks-3.9.2.tar.gz luarocks-3.9.2

# Install OpenSSL module
RUN luarocks install openssl

RUN apt-get install -y git
RUN apt-get install -y libssl-dev
RUN apt-get install -y build-essential
RUN apt-get install -y authbind
RUN apt-get install -y lsb-core
RUN apt-get -y install --no-install-recommends wget gnupg ca-certificates
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN echo "deb http://openresty.org/package/arm64/ubuntu $(lsb_release -sc) main" > openresty.list
RUN cp openresty.list /etc/apt/sources.list.d/
RUN apt-get update
RUN apt-get -y install --no-install-recommends openresty

# Install PostgreSQL and other dependencies
RUN apt-get install -y postgresql postgresql-client postgresql-contrib
RUN apt-get install -y git
RUN apt-get install -y libssl-dev
RUN apt-get install -y build-essential
RUN apt-get install -y authbind
RUN apt-get install -y lsb-core

# Install OpenResty
RUN apt-get -y install --no-install-recommends wget gnupg ca-certificates
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN echo "deb http://openresty.org/package/arm64/ubuntu $(lsb_release -sc) main" > openresty.list
RUN cp openresty.list /etc/apt/sources.list.d/
RUN apt-get update
RUN apt-get -y install --no-install-recommends openresty

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

COPY /app /app

# Install Lua projects
RUN luarocks install lub
RUN luarocks install openssl
RUN if test -d /usr/lib/aarch64-linux-gnu; then ln -s /usr/lib/aarch64-linux-gnu /usr/lib/x86_64-linux-gnu; else echo "Directory does not exist"; fi

# git:// is not supported using https://
RUN git config --global url."https://".insteadOf git://


WORKDIR /app
# Install Snap! Cloud

RUN luarocks install snap-cloud-beta-0.rockspec

# Setup Database
RUN service postgresql start \
  && su postgres -c "psql -c \"CREATE USER cloud WITH PASSWORD 'snap-cloud-password';\"" \
  && su postgres -c "psql -c \"ALTER USER cloud WITH LOGIN;\"" \
  && su postgres -c "psql -c \"CREATE DATABASE snapcloud WITH OWNER cloud;\"" \
  && su postgres -c "psql -d snapcloud -a -f /app/cloud.sql" \
  && su postgres -c "psql -d snapcloud -c \"GRANT ALL PRIVILEGES ON DATABASE snapcloud TO cloud;\"" \
  && su postgres -c "psql -d snapcloud -a -f /app/bin/seeds.sql"

ENV DATABASE_PASSWORD=password

# Create cloud user and set permissions
RUN adduser cloud --disabled-password --gecos "";
RUN chown -R cloud:cloud /app

COPY migrations.patch /app/migrations.patch
RUN patch migrations.lua < migrations.patch

RUN service postgresql start \
  && su - cloud -c "cd /app && ./bin/migrations.sh"

RUN mkdir /app/store
RUN chmod -R 0777 /app/store

# env file for snap cloud
COPY env.sh /app/.env
# start script
copy start.sh /app/start.sh

# Set port
ENV PORT=80
EXPOSE 80

CMD ["/app/start.sh"]
