# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.


# WIP couchdb2 alpine

# using alpine:3.4
# - mozjs didn't compile under 3.5
FROM alpine:3.4

# build mozjs
RUN apk add --no-cache --virtual .mozjs-build-deps \
     curl perl g++ python zip make \
  && mkdir -p /usr/src/mozjs && cd /usr/src/mozjs \
  && curl http://ftp.mozilla.org/pub/js/js185-1.0.0.tar.gz > ./mozjs.tar.gz \
  && tar -xzf mozjs.tar.gz && cd /usr/src/mozjs/js-1.8.5/js/src \
  && ./configure --prefix=/usr && make && make install \
  && apk del .mozjs-build-deps \
  && rm -rf /usr/src /var/cache/apk/*

# build couchdb2
# - TODO: test which erlang packages are actually necessary
# - TODO: add fauxton deps (disabled atm)
RUN apk add --no-cache --virtual .build-deps \
    curl perl g++ python make icu-dev nodejs \
    && apk add --no-cache \
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
      erlang-diameter \
  && npm install -g grunt-cli \
  && mkdir -p /usr/src && cd /usr/src \
  && curl -fSL https://dist.apache.org/repos/dist/release/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz -o couchdb.tar.gz \
  && tar -xzf couchdb.tar.gz \
  && cd /usr/src/apache-couchdb-2.0.0 \
  && ./configure --disable-docs \
  && make release \
  && mkdir /opt && mv rel/couchdb /opt/ \
  && npm uninstall -g grunt-cli \
  && apk del .build-deps \
  && apk add --no-cache icu \
  && rm -rf /usr/lib/node_modules /usr/src /var/cache/apk/* \
  && mkdir /opt/couchdb/data /opt/couchdb/etc/local.d /opt/couchdb/etc/default.d

# config files from
# https://github.com/klaemo/docker-couchdb/tree/master/2.0.0
COPY local.ini /opt/couchdb/etc/
COPY vm.args /opt/couchdb/etc/

WORKDIR /opt/couchdb
EXPOSE 5984 4369 9100
VOLUME ["/opt/couchdb/data"]

CMD ["/opt/couchdb/bin/couchdb"]
