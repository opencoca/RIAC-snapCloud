FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y lua5.1 liblua5.1-0-dev
RUN apt-get install -y luarocks
RUN apt-get install libssl1.1

# Install PostgreSQL and create a new database and user
RUN apt-get install -y postgresql  postgresql-client postgresql-contrib \
  && service postgresql start \
  && su postgres -c "psql -c \"CREATE USER cloud WITH PASSWORD 'password';\"" \
  && su postgres -c "psql -c \"CREATE DATABASE snapcloud WITH OWNER cloud;\"" 

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
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

COPY /app /app

RUN luarocks install lub
RUN luarocks install openssl
RUN if test -d /usr/lib/aarch64-linux-gnu; then ln -s /usr/lib/aarch64-linux-gnu /usr/lib/x86_64-linux-gnu; else echo "Directory does not exist"; fi

RUN git config --global url."https://".insteadOf git://

RUN luarocks install /app/snap-cloud-beta-0.rockspec

RUN service postgresql start \
  && su postgres -c "psql -d snapcloud -a -f /app/cloud.sql"

COPY env /app/.env
copy start.sh /app/start.sh

WORKDIR /app
CMD ["/app/start.sh"]
