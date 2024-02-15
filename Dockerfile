FROM alpine:3.19

RUN apk update
RUN apk add gcc g++ vim git cmake make bash python3 ninja py3-packaging linux-headers meson

WORKDIR /usr/src
RUN git clone https://github.com/libsdl-org/SDL.git -b SDL2
WORKDIR /usr/src/SDL
RUN mkdir -vp build
WORKDIR /usr/src/SDL/build
RUN cmake .. -DVIDEO_X11=OFF -DVIDEO_WAYLAND=OFF -DOSS=OFF -DDISKAUDIO=OFF -DVIDEO_DUMMY=OFF -DCMAKE_INSTALL_PREFIX=/usr -DSDL_SHARED=OFF -DSDL_ALSA=ON
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
ADD https://download.qemu.org/qemu-8.2.1.tar.xz .
RUN tar xJf qemu-8.2.1.tar.xz
WORKDIR /usr/src/qemu-8.2.1
RUN apk add pkgconfig
RUN ./configure --prefix=/usr --static --target-list=x86_64-softmmu
RUN make -j $(nproc)
