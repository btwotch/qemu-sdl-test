FROM alpine:3.19

RUN apk update
RUN apk add gcc g++ vim git cmake make bash python3 ninja py3-packaging linux-headers meson libpciaccess-dev #libdrm-dev libepoxy-dev mesa-dev

WORKDIR /usr/src
RUN git clone https://github.com/libsdl-org/SDL.git -b SDL2
WORKDIR /usr/src/SDL
RUN mkdir -vp build
WORKDIR /usr/src/SDL/build
RUN cmake .. -DVIDEO_X11=OFF -DVIDEO_WAYLAND=OFF -DOSS=OFF -DDISKAUDIO=OFF -DVIDEO_DUMMY=OFF -DCMAKE_INSTALL_PREFIX=/usr -DSDL_SHARED=OFF -DSDL_ALSA=ON -DSDL_X11=OFF
RUN make -j $(nproc)
RUN make install

WORKDIR /usr/src
ADD https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.3.tar.gz .
RUN tar xf util-linux-2.39.3.tar.gz
WORKDIR /usr/src/util-linux-2.39.3
RUN ./configure --prefix=/usr/local --enable-static
RUN make -j $(nproc)
RUN make install

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

WORKDIR /usr/src
ADD https://download.gnome.org/sources/glib/2.79/glib-2.79.1.tar.xz .
RUN tar xf glib-2.79.1.tar.xz
WORKDIR /usr/src/glib-2.79.1
RUN meson setup build --prefer-static --prefix=/usr/local --default-library static
WORKDIR /usr/src/glib-2.79.1/build
RUN ninja
RUN ninja install

WORKDIR /usr/src
ADD https://gitlab.freedesktop.org/mesa/drm/-/archive/libdrm-2.4.120/drm-libdrm-2.4.120.tar.gz .
RUN tar xf drm-libdrm-2.4.120.tar.gz
WORKDIR /usr/src/drm-libdrm-2.4.120
RUN meson setup builddir --prefer-static --prefix=/usr/local --default-library static
WORKDIR /usr/src/drm-libdrm-2.4.120/builddir
RUN ninja
RUN meson install

#RUN apk add autoconf automake
#RUN apk add util-macros xorgproto
#WORKDIR /usr/src
#ADD https://gitlab.freedesktop.org/xorg/lib/libxext/-/archive/libXext-1.3.6/libxext-libXext-1.3.6.tar.bz2 .
#RUN tar xf libxext-libXext-1.3.6.tar.bz2
#WORKDIR /usr/src/libxext-libXext-1.3.6


RUN apk add libvdpau-dev glslang-dev py3-mako llvm17-dev byacc flex
RUN apk add glslang-static
RUN apk add wayland-dev
RUN apk add libx11-dev
#RUN apk add libxext-dev
RUN apk add libxfixes-dev
RUN apk add libxshmfence-dev
RUN apk add libxxf86vm-dev
RUN apk add libxrandr-dev
RUN apk add elfutils-dev
ARG MESA_VERSION=24.0.1
WORKDIR /usr/src
ADD https://archive.mesa3d.org/mesa-$MESA_VERSION.tar.xz .
RUN tar xf mesa-$MESA_VERSION.tar.xz
WORKDIR /usr/src/mesa-$MESA_VERSION
RUN meson setup builddir
# TODO: make static
#RUN meson setup builddir --prefer-static --prefix=/usr/local --default-library static
WORKDIR /usr/src/mesa-$MESA_VERSION/builddir
RUN ninja || true

#WORKDIR /usr/src
#ADD https://download.qemu.org/qemu-8.2.1.tar.xz .
#RUN tar xJf qemu-8.2.1.tar.xz
#WORKDIR /usr/src/qemu-8.2.1
#RUN apk add pkgconfig
#RUN ./configure --prefix=/usr --static --target-list=x86_64-softmmu
#RUN make -j $(nproc) || true
