FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install vim build-essential golang-go git libdrm-dev apt-file cmake libdirectfb-dev libgbm-dev wget python3 python3-setuptools python3-pip ninja-build libglib2.0-dev flex bison

RUN apt-get -y dist-upgrade
RUN apt-file update

WORKDIR /usr/src
RUN git clone https://github.com/libsdl-org/SDL.git -b SDL2
WORKDIR /usr/src/SDL
RUN mkdir -vp build
WORKDIR /usr/src/SDL/build
RUN cmake .. -DVIDEO_X11=OFF -DVIDEO_WAYLAND=OFF -DOSS=OFF -DDISKAUDIO=OFF -DVIDEO_DUMMY=OFF -DCMAKE_INSTALL_PREFIX=/usr
RUN make -j $(nproc)
RUN make install

WORKDIR /usr/src
RUN wget https://download.qemu.org/qemu-8.2.0.tar.xz
RUN tar xvJf qemu-8.2.0.tar.xz
WORKDIR /usr/src/qemu-8.2.0
RUN ./configure --prefix=/usr
RUN make -j $(nproc)

