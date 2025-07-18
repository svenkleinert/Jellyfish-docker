FROM debian:12

LABEL org.opencontainers.image.authors="sven.kleinert@phoenixd.uni-hannover.de"
LABEL version=1.0

ARG QT_VERSION="6.8.2"

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/*

RUN \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

ENV QT_BUILT_DEPS="\
build-essential \
ca-certificates \
clang \
cmake \
libclang-dev \
libegl1-mesa-dev \
libfontconfig1-dev \
libfreetype-dev \
libopengl-dev \
libx11-dev \
libx11-xcb-dev \
libxcb-cursor-dev \
libxcb-glx0-dev \
libxcb-icccm4-dev \
libxcb-image0-dev \
libxcb-keysyms1-dev \
libxcb-randr0-dev \
libxcb-render-util0-dev \
libxcb-shape0-dev \
libxcb-shm0-dev \
libxcb-sync-dev \
libxcb-util-dev \
libxcb-xfixes0-dev \
libxcb-xinerama0-dev \
libxcb-xkb-dev \
libxcb1-dev \
libxcursor-dev \
libxext-dev \
libxfixes-dev \
libxi-dev \
libxkbcommon-dev \
libxkbcommon-x11-dev \
libxrender-dev \
llvm \
llvm-14-dev \
ninja-build \
python3 \
wget \
"


# compile/install qt
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install $QT_BUILT_DEPS && \
    cd /opt && \
    wget -q https://download.qt.io/official_releases/qt/${QT_VERSION%.*}/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz &&\
    tar xf qt-everywhere-src-${QT_VERSION}.tar.xz && \
    cd /opt/qt-everywhere-src-${QT_VERSION} && \
    ./configure -prefix /usr/local/Qt6 -opensource -confirm-license -release -nomake tests -nomake examples && \
    cmake --build . --parallel 4 && \
    cmake --install . && \
    cd /opt && \
    rm -rf qt-everywhere-src-${QT_VERSION} && \
    rm -rf qt-everywhere-src-${QT_VERSION}.tar.xz && \
    apt-get -y remove  $QT_BUILT_DEPS && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV LIBCINT_BUILT_DEPS="\
build-essential \
cmake \
git \
libopenblas-dev \
"

ARG LIBCINT_VERSION="6.1.2"
# compile/install libcint
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install $LIBCINT_BUILT_DEPS && \
    cd /opt && \
    git clone http://github.com/sunqm/libcint.git && \
    cd /opt/libcint && \
    git checkout v${LIBCINT_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/libcint -DBUILD_SHARED_LIBS=0 -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . --target install && \
    rm -r /opt/libcint &&\
    apt-get -y remove $LIBCINT_BUILT_DEPS && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV MUPARSER_BUILT_DEPS="\
build-essential \
cmake \
git \
"

ARG MUPARSER_VERSION="2.3.5"
# compile/install muparser
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install $MUPARSER_BUILT_DEPS && \
    cd /opt && \
    git clone https://github.com/beltoforion/muparser.git && \
    cd /opt/muparser && \
    git checkout v${MUPARSER_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/muparser -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . --target install && \
    rm -r /opt/muparser &&\
    apt-get -y remove $MUPARSER_BUILT_DEPS && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV EIGEN_BUILT_DEPS="\
git"

# download eigen
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install $EIGEN_BUILT_DEPS && \
    cd /usr/local && \
    git clone https://gitlab.com/libeigen/eigen.git && \
    apt-get -y remove $EIGEN_BUILT_DEPS && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV VTK_BUILT_DEPS="\
build-essential \
cmake \
libgl1-mesa-dev \
libopengl-dev \
libopenmpi-dev \
wget \
"

ARG VTK_VERSION="9.3.0"
# compile/install vtk
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install $VTK_BUILT_DEPS && \
    cd /opt && \
    wget -q https://www.vtk.org/files/release/${VTK_VERSION%.*}/VTK-${VTK_VERSION}.tar.gz && \
    tar -xvzf VTK-${VTK_VERSION}.tar.gz &&\
    cd /opt/VTK-${VTK_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. \
    -DBUILD_SHARED_LIBS:BOOL=OFF \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DVTK_ENABLE_LOGGING:BOOL=OFF \
    -DVTK_ENABLE_WRAPPING:BOOL=OFF \
    -DVTK_QT_VERSION:STRING=6 \
    -DQT_QMAKE_EXECUTABLE:PATH=/usr/local/Qt6/bin/qmake \
    -DVTK_GROUP_ENABLE_Qt:STRING=YES \
    -DCMAKE_PREFIX_PATH:PATH=/usr/local/Qt6/lib/cmake \
    -DVTK_MODULE_ENABLE_VTK_GUISupportQtSQL:STRING=NO \
    -DVTK_MODULE_ENABLE_VTK_hdf5:STRING=NO \
    -DVTK_MODULE_ENABLE_VTK_GUISupportQtQuick:STRING=DONT_WANT \
    -DVTK_MODULE_ENABLE_VTK_RenderingContextOpenGL2:STRING=YES \
    -DVTK_MODULE_ENABLE_VTK_RenderingLICOpenGL2:STRING=DONT_WANT \
    -DVTK_MODULE_ENABLE_VTK_RenderingCellGrid:STRING=NO \
    -DVTK_MODULE_ENABLE_VTK_sqlite:STRING=NO \
    -DCMAKE_INSTALL_PREFIX=/usr/local/VTK && \
    cmake --build . -j4 && \
    cmake --install . && \
    rm -rf /opt/VTK-${VTK_VERSION} && \
    rm -rf /opt/VTK-${VTK_VERSION}.tar.gz &&\
    apt-get -y remove $VTK_BUILT_DEPS && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV QUEST_BUILT_DEPS="\
build-essential \
cmake \
git \
"

ARG QUEST_VERSION="3.7.0"

# compile/install QuEST
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install $QUEST_BUILT_DEPS && \
    cd /opt && \
    git clone https://github.com/quest-kit/QuEST.git && \
    cd /opt/QuEST && \
    git checkout v${QUEST_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . -j4 && \
    mkdir /usr/local/QuEST && \
    mkdir /usr/local/QuEST/lib && \
    cp QuEST/libQuEST.a /usr/local/QuEST/lib && \
    cp -r ../QuEST/include /usr/local/QuEST/include && \
    rm -rf /opt/QuEST && \
    apt-get -y remove $QUEST_BUILT_DEPS && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*
