## SPDX-License-Identifier: GPL-2.0
# @note see bottom of dockerfile for information
FROM golang:buster AS go-build

# Build /go/bin/obfs4proxy & /go/bin/meek-server
RUN go get -v git.torproject.org/pluggable-transports/obfs4.git/obfs4proxy \
 && go get -v git.torproject.org/pluggable-transports/meek.git/meek-server \
 && cp -rv /go/bin /usr/local/

FROM debian:buster-slim

WORKDIR /opt/tornado4

ARG GPGKEY=A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="True"
ARG DEBIAN_FRONTEND=noninteractive
ARG found=""

ENV TERM=xterm \
    TOR_ORPORT=7000 \
    TOR_DIRPORT=9030 \
    TOR_DIR=/opt/tornado4 \
    TOR_USER=tord \
    TOR_NICKNAME=TORNADO4

RUN mkdir -p  ${TOR_DIR}

# Using apt-get update alone in a RUN statement causes caching issues and subsequent apt-get install
# 
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y -qq \
        apt-transport-https \
        ca-certificates \
        dirmngr \
        apt-utils \
        gnupg \
        curl \
 # @note torproject.org Debian repository for stable Tor version
 && curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import \
 && gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - \
 && echo "deb https://deb.torproject.org/torproject.org buster main"   >  /etc/apt/sources.list.d/tor-apt-sources.list \
 && echo "deb-src https://deb.torproject.org/torproject.org buster main" >> /etc/apt/sources.list.d/tor-apt-sources.list \
 # @note install tor with GeoIP and obfs4proxy & backup torrc
 && apt-get update && apt-get install --no-install-recommends --no-install-suggests -y -qq \
        pwgen \
        iputils-ping \
        tor \
        tor-geoipdb \
        deb.torproject.org-keyring \
 && mkdir -pv /usr/local/etc/tor/ \
 && mv -v /etc/tor/torrc /usr/local/etc/tor/torrc.sample \
 && apt-get purge --auto-remove -y \
        apt-transport-https \
        dirmngr \
        apt-utils \
        gnupg \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # Rename Debian unprivileged user to tord \
 && usermod -l tord debian-tor \
 && groupmod -n tord debian-tor

FROM debian:buster-slim

COPY --from=go-build /usr/local/bin/ /usr/local/bin/

RUN adduser --disabled-password --gecos "" --home /opt/tornado4 tornado4 && \
    chown -R tornado4:tornado4 /opt/tornado4 /usr/local/bin/

USER tornado4
# Copy obfs4proxy & meek-server


# Copy the base tor configuration file
COPY ./config/torrc* /etc/tor/

# @note Copy docker-entrypoint
COPY ./scripts/ /usr/local/bin/

# @note Persist data
VOLUME /etc/tor /var/lib/tor

# @note ORPort, DirPort, SocksPort, ObfsproxyPort, MeekPort
EXPOSE 9001 9030 9050  54444 7002 9051

# @note used for debuging, enable for troubleshooting
# ENV OTEL_RESOURCE_ATTRIBUTES="service.name=tor-$VERSION"

ENTRYPOINT ["docker-entrypoint"]
CMD ["tor", "-f", "/etc/tor/torrc"]
HEALTHCHECK --start-period=5s --interval=5s --timeout=1s --retries=10 CMD bash -c "[ -f /tmp/pid ]"
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="tornado4" \
      org.label-schema.description="Tornado Cash TOR Relay" \
      org.label-schema.url="https://2019.www.torproject.org/index.html.en" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/sambacha/tornado-onion.git" \
      org.label-schema.vendor="Tor" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

# based off of chriswayg's <chriswayg@gmail.com> base docker image 
# Dockerfile for Tor Relay Server with obfs4proxy (Multi-Stage build)
# Usage:
#   This works best using a docker compose command so you can run the
#   necessary other servers for it to talk to. But if you want o run
#   manually:
#   docker run --rm -it -e ROLE=DA $PWD/tor-server /bin/bash
