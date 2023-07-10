FROM raspios-bullseye-arm64-lite

# Install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install \
    --auto-remove --purge --no-install-suggests --no-install-recommends \
    git \
    libklibc-dev \
    nfs-common \
    btrfs-progs \
    zstd \
    bindfs \
    cryptsetup \
    cryptsetup-initramfs \
    zram-tools \
    earlyoom \
    network-manager- \
    dphys-swapfile-
RUN apt-get clean

# Configure
COPY --chown=root:root template /

RUN /opt/init/compile
RUN /opt/init/configure

ENV DEBIAN_FRONTEND=
CMD [ "/sbin/init" ]
