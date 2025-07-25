FROM svenkleinert/jellyfish-build:1.0

LABEL org.opencontainers.image.authors="sven.kleinert@phoenixd.uni-hannover.de"
LABEL version=1.0

ARG JELLYFISH_REPO="https://github.com/FabianLangkabel/Jellyfish.git"

ENV JELLYFISH_BUILT_DEPS="\
build-essential \
cmake \
libgl1-mesa-dev \
libopenblas-dev \
libopengl-dev \
libxcb-cursor-dev \
libxkbcommon0 \
libzip-dev \
git \
libc-devtools \
"

RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install $JELLYFISH_BUILT_DEPS && \
    cd /opt && \
    git clone $JELLYFISH_REPO /opt/Jellyfish && \
    cd /opt/Jellyfish && \
    mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build . -j4 && \
    mkdir JellyfishGUI/Plugins && \
    mkdir JellyfishGUI/basissets && \
    cp Plugins/Basics/libBasics.so JellyfishGUI/Plugins && \
    cp Plugins/OrcaInterface/libOrcaInterface.so JellyfishGUI/Plugins && \
    cp Plugins/Visualization/libVisualization.so JellyfishGUI/Plugins && \
    cp Plugins/QuantumComputing/libQuantumComputing.so JellyfishGUI/Plugins && \
    mkdir JellyfishCMD/Plugins && \
    mkdir JellyfishCMD/basissets && \
    cp Plugins/Basics/libBasics.so JellyfishCMD/Plugins && \
    cp Plugins/OrcaInterface/libOrcaInterface.so JellyfishCMD/Plugins && \
    cp Plugins/Visualization/libVisualization.so JellyfishCMD/Plugins && \
    cp Plugins/QuantumComputing/libQuantumComputing.so JellyfishCMD/Plugins && \
    mv /opt/Jellyfish/build/JellyfishGUI /JellyfishGUI && \
    mv /opt/Jellyfish/build/JellyfishCMD /JellyfishCMD && \
    rm -rf /opt/* && \
    apt-get -y remove $JELLYFISH_BUILT_DEPS && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*


ENV JELLYFISH_RUNTIME_DEPS="\
libfontconfig1 \
libc6 \
libegl1 \
libglx0 \
libgomp1 \
libopengl0 \
libopenmpi3 \
libxcb-cursor0 \
libxcb-icccm4 \
libxcb-keysyms1 \
libxcb-shape0 \
libxcb-xkb1 \
libxkbcommon0 \
libxkbcommon-x11-0 \
libzip4 \
xcb"

RUN \
    apt-get update && \
    apt-get -y install $JELLYFISH_RUNTIME_DEPS --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# create possible entrypoints
RUN \
echo '#!/bin/bash\n \
    cd /JellyfishGUI/\n \
    ./JellyfishGUI \
    ' > /usr/local/bin/JellyfishGUI && \
    chmod +x /usr/local/bin/JellyfishGUI

RUN \
    echo '#!/bin/bash\n \
    cd /JellyfishCMD/\n \
    ./JellyfishCMD \
    ' > /usr/local/bin/JellyfishCMD && \
    chmod +x /usr/local/bin/JellyfishCMD

ENTRYPOINT ["/usr/local/bin/JellyfishGUI"]
