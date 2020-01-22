FROM ubuntu:eoan AS zip_downloader
LABEL maintainer="Pawel Kosciewicz <pawkos@gmail.com>"
CMD bash

ARG REPERTORY_VERSION="1.2.0-release_cd9e992"
ARG REPERTORY_PACKAGE="repertory_${REPERTORY_VERSION}_debian9"
ARG REPERTORY_ZIP="${REPERTORY_PACKAGE}.zip"
ARG REPERTORY_RELEASE="https://bitbucket.org/blockstorage/repertory/downloads/${REPERTORY_ZIP}"

RUN apt-get update
RUN apt-get install -y \
      wget \
      unzip

RUN wget "$REPERTORY_RELEASE" && \
      mkdir /repertory && \
      unzip -j "$REPERTORY_ZIP" -d /repertory

FROM ubuntu:eoan
ARG REPERTORY_DIR="/repertory"

COPY --from=zip_downloader /repertory "${REPERTORY_DIR}"

RUN apt-get update
RUN apt-get install -y socat

# Required system packages
RUN apt-get update && apt-get -y install

EXPOSE 20000

WORKDIR "$REPERTORY_DIR"

ENV REPERTORY_DATA_DIR "/mnt/repertory"

ENTRYPOINT ./repertory -o big_writes "$REPERTORY_DATA_DIR"
