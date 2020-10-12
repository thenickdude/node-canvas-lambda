FROM amazonlinux:latest

ARG LIBS=/usr/lib64
ARG OUT=/root/layers
ARG NODE_VERSION=12

# set up container
RUN yum -y update \
&& yum -y groupinstall "Development Tools" \
&& curl --silent --location https://rpm.nodesource.com/setup_${NODE_VERSION}.x | bash - \
&& yum install -y nodejs gcc-c++ cairo-devel libjpeg-turbo-devel pango-devel giflib-devel libgif-dev librsvg2-devel gdk-pixbuf2-devel
# && yum install -y nodejs cairo cairo-devel cairomm-devel libjpeg-turbo-devel pango pango-devel pangomm pangomm-devel giflib-devel

RUN node --version

# will be created and become working dir
WORKDIR $OUT/nodejs

RUN npm install npm install https://github.com/Automattic/node-canvas.git#v2.7.0 --build-from-source

# will be created and become working dir
WORKDIR $OUT/lib

# gather missing libraries
RUN cp $LIBS/libEGL.so.1 . \
&& cp $LIBS/libGL.so.1 . \
&& cp $LIBS/libGLX.so.0 . \
&& cp $LIBS/libGLdispatch.so.0 . \
&& cp $LIBS/libICE.so.6 . \
&& cp $LIBS/libSM.so.6 . \
&& cp $LIBS/libX11.so.6 . \
&& cp $LIBS/libXau.so.6 . \
&& cp $LIBS/libXext.so.6 . \
&& cp $LIBS/libXrender.so.1 . \
&& cp $LIBS/libblkid.so.1 . \
&& cp $LIBS/libbz2.so.1 . \
&& cp $LIBS/libcairo.so.2 . \
&& cp $LIBS/libcroco-0.6.so.3 . \
&& cp $LIBS/libexpat.so.1 . \
&& cp $LIBS/libfontconfig.so.1 . \
&& cp $LIBS/libfreetype.so.6 . \
&& cp $LIBS/libfribidi.so.0 . \
&& cp $LIBS/libgdk_pixbuf-2.0.so.0 . \
&& cp $LIBS/libgif.so.4 . \
&& cp $LIBS/libgio-2.0.so.0 . \
&& cp $LIBS/libglib-2.0.so.0 . \
&& cp $LIBS/libgmodule-2.0.so.0 . \
&& cp $LIBS/libgobject-2.0.so.0 . \
&& cp $LIBS/libgraphite2.so.3 . \
&& cp $LIBS/libgthread-2.0.so.0 . \
&& cp $LIBS/libharfbuzz.so.0 . \
&& cp $LIBS/libjpeg.so.62 . \
&& cp $LIBS/liblzma.so.5 . \
&& cp $LIBS/libmount.so.1 . \
&& cp $LIBS/libpango-1.0.so.0 . \
&& cp $LIBS/libpangocairo-1.0.so.0 . \
&& cp $LIBS/libpangoft2-1.0.so.0 . \
&& cp $LIBS/libpixman-1.so.0 . \
&& cp $LIBS/libpng15.so.15 . \
&& cp $LIBS/librsvg-2.so.2 . \
&& cp $LIBS/libthai.so.0 . \
&& cp $LIBS/libuuid.so.1 . \
&& cp $LIBS/libxcb-render.so.0 . \
&& cp $LIBS/libxcb-shm.so.0 . \
&& cp $LIBS/libxcb.so.1 . \
&& cp $LIBS/libxml2.so.2 .

WORKDIR $OUT

RUN zip -r -9 node${NODE_VERSION}_canvas_layer.zip nodejs \
&& zip -r -9 node${NODE_VERSION}_canvas_lib64_layer.zip lib

ENTRYPOINT ["zip","-r","-9"]
CMD ["/out/layers.zip", $OUT]