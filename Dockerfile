FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG REPERTORY_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="pawkos"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
	 apt-get install -y \
	 curl \
	 unzip \
	 jq \
	 libfuse-dev && \
 echo "**** install repertory ****" && \
 if [ -z ${REPERTORY_RELEASE+x} ]; then \
	REPERTORY_RELEASE=$(curl -sX GET "https://api.bitbucket.org/2.0/repositories/blockstorage/repertory/downloads?pagelen=100" \
	| jq -r 'first(.values[] | select(.links.self.href | endswith("_ubuntu18.04.zip")).links.self.href)'); \
 fi && \
 curl -o \
 /tmp/repertory.zip -L \
      "${REPERTORY_RELEASE}" && \
 mkdir -p /app/repertory && \
 unzip /tmp/repertory.zip -d /app/repertory && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 20000
VOLUME /config
