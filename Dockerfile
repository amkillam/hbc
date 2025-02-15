FROM debian:bullseye-slim

LABEL maintainer="devkitPro developers support@devkitpro.org"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-get install -y --no-install-recommends sudo ca-certificates pkg-config curl wget bzip2 xz-utils make libarchive-tools doxygen gnupg && \
  apt-get install -y --no-install-recommends git git-restore-mtime && \
  apt-get install -y --no-install-recommends rsync && \
  apt-get install -y --no-install-recommends cmake zip unzip ninja-build && \
  apt-get install -y --no-install-recommends python3 python-is-python3 python3-lz4 && \
  apt-get install -y --no-install-recommends locales && \
  apt-get install -y --no-install-recommends patch && \
  apt-get install -y  libpng-dev gettext sox libsox-dev \
  xxd libc-devtools build-essential libmxml-dev \
  python2 python-dev && \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py && \
  python2 /tmp/get-pip.py && \
  rm /tmp/get-pip.py
RUN python2 -m pip install --no-cache-dir pycrypto pycryptodomex


RUN ln -s /proc/mounts /etc/mtab && \
  wget https://apt.devkitpro.org/install-devkitpro-pacman && \
  chmod +x ./install-devkitpro-pacman && \
  ./install-devkitpro-pacman && \
  rm ./install-devkitpro-pacman && \
  dkp-pacman --disable-download-timeout -Syyu --noconfirm && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm dkp-toolchain-vars dkp-meson-scripts && \
  yes | dkp-pacman --disable-download-timeout -Scc


ENV LANG=en_US.UTF-8

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

LABEL maintainer="devkitPro developers support@devkitpro.org"

RUN dkp-pacman --disable-download-timeout -Syyu --noconfirm gamecube-dev wii-dev wiiu-dev && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm ppc-portlibs gamecube-portlibs wii-portlibs wiiu-portlibs && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm devkitARM && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm 3ds-dev nds-dev gp32-dev gba-dev gp2x-dev && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm 3ds-portlibs nds-portlibs armv4t-portlibs && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm switch-dev && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm switch-portlibs && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm dkp-toolchain-vars hactool && \
  dkp-pacman --disable-download-timeout -S --needed --noconfirm ppc-zlib ppc-libpng ppc-mxml ppc-freetype wii-dev && \
  yes | dkp-pacman -Scc

RUN mkdir -p ~/.wii/dpki && \
  echo 'ebe42a225e8593e448d9c5457381aaf7' > ~/.wii/common-key.txt && \
  cp ~/.wii/common-key.txt ~/.wii/dpki/common-key.txt

ENV DEVKITPPC=${DEVKITPRO}/devkitPPC
ENV DEVKITARM=${DEVKITPRO}/devkitARM

