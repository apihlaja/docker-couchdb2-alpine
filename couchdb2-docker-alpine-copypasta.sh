# using alpine:3.4
# - mozjs didn't compile under 3.5
docker run -it --rm alpine:3.4 /bin/sh

# build mozjs
apk update \
  && apk add curl perl g++ python zip make \
  && mkdir -p /usr/src/mozjs && cd /usr/src/mozjs \
  && curl http://ftp.mozilla.org/pub/js/js185-1.0.0.tar.gz > ./mozjs.tar.gz \
  && tar -xzf mozjs.tar.gz && cd /usr/src/mozjs/js-1.8.5/js/src \
  && ./configure --prefix=/usr && make && make install

# more build deps
# - TODO: test which erlang packages are actually necessary
apk add \
  icu-dev \
  erlang-xmerl \
  erlang-dialyzer \
  erlang-cosproperty \
  erlang-parsetools \
  erlang-costime \
  erlang-test-server \
  erlang-percept \
  erlang-sasl \
  erlang-stdlib \
  erlang-runtime-tools \
  erlang-ssh \
  erlang-erl-docgen \
  erlang-eunit \
  erlang \
  erlang-inets \
  erlang-orber \
  erlang-cosfiletransfer \
  erlang-tools \
  erlang-snmp \
  erlang-et \
  erlang-ic \
  erlang-dev \
  erlang-debugger \
  erlang-jinterface \
  erlang-typer \
  erlang-asn1 \
  erlang-erl-interface \
  erlang-hipe \
  erlang-cosnotification \
  erlang-odbc \
  erlang-ose \
  erlang-otp-mibs \
  erlang-reltool \
  erlang-crypto \
  erlang-common-test \
  erlang-ssl \
  erlang-mnesia \
  erlang-cosevent \
  erlang-compiler \
  erlang-os-mon \
  erlang-erts \
  erlang-costransaction \
  erlang-public-key \
  erlang-syntax-tools \
  erlang-gs \
  erlang-observer \
  erlang-edoc \
  erlang-kernel \
  erlang-webtool \
  erlang-eldap \
  erlang-coseventdomain \
  erlang-megaco \
  erlang-diameter
  
# build couchdb2
# - TODO: add fauxton deps (disabled atm)
cd /usr/src \
  && curl -fSL https://dist.apache.org/repos/dist/release/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz -o couchdb.tar.gz \
  && tar -xzf couchdb.tar.gz \
  && cd /usr/src/apache-couchdb-2.0.0 \
  && ./configure --disable-docs --disable-fauxton \
  && make release 
  
# du -ch /
# 533.1M  total
