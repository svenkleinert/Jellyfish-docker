FROM debian:12

RUN apt-get update && \
    apt-get install -y locales

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

ENV QT_BUILT_DEPS="\
build-essential \
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
ninja-build \
wget \
"

RUN \
    apt-get update && \
    apt-get -y install $QT_BUILT_DEPS && \
    cd /opt && \
    wget -q https://download.qt.io/official_releases/qt/6.8/6.8.2/single/qt-everywhere-src-6.8.2.tar.xz &&\
    tar xf qt-everywhere-src-6.8.2.tar.xz && \
    cd /opt/qt-everywhere-src-6.8.2 && \
    ./configure -prefix /usr/local/Qt6 -opensource -confirm-license -release -nomake tests -nomake examples && \
    cmake --build . --parallel 4 && \
    cmake --install . && \
    cd /opt && \
    rm -rf qt-everywhere-src-6.8.2 && \
    rm -rf qt-everywhere-src-6.8.2.tar.xz && \
    apt-get -y remove  $QT_BUILT_DEPS && \
    apt-get -y autoremove

ENV LIBCINT_BUILT_DEPS="\
build-essential \
cmake \
libopenblas-dev \
git \
"

# compile/install libcint
RUN \
    apt-get -y install $LIBCINT_BUILT_DEPS && \
    cd /opt && \
    git clone http://github.com/sunqm/libcint.git && \
    cd /opt/libcint && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/libcint -DBUILD_SHARED_LIBS=0 -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . --target install && \
    rm -r /opt/libcint &&\
    apt-get -y remove $LIBCINT_BUILT_DEPS && \
    apt-get -y autoremove

ENV MUPARSER_BUILT_DEPS="\
build-essential \
cmake \
git \
"

# compile/install muparser
RUN \
    apt-get -y install $MUPARSER_BUILT_DEPS && \
    cd /opt && \
    git clone https://github.com/beltoforion/muparser.git && \
    cd /opt/muparser && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/muparser -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . --target install && \
    rm -r /opt/muparser &&\
    apt-get -y remove $MUPARSER_BUILT_DEPS && \
    apt-get -y autoremove

ENV EIGEN_BUILT_DEPS="\
git"

# download eigen
RUN \
    apt-get -y install $EIGEN_BUILT_DEPS && \
    cd /usr/local && \
    git clone https://gitlab.com/libeigen/eigen.git && \
    apt-get -y remove $EIGEN_BUILT_DEPS && \
    apt-get -y autoremove

ENV VTK_BUILT_DEPS="\
build-essential \
cmake \
libgl1-mesa-dev \
libopengl-dev \
libopenmpi-dev \
wget \
"

# download vtk
RUN \
    apt-get -y install $VTK_BUILT_DEPS && \
    cd /opt && \
    wget -q https://www.vtk.org/files/release/9.3/VTK-9.3.0.tar.gz && \
    tar -xvzf VTK-9.3.0.tar.gz &&\
    cd /opt/VTK-9.3.0 && \
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
    rm -rf /opt/VTK-9.3.0 && \
    rm -rf /opt/VTK-9.3.0.tar.gz &&\
    apt-get -y remove $VTK_BUILT_DEPS && \
    apt-get -y autoremove

ENV QUEST_BUILT_DEPS="\
build-essential \
cmake \
git \
"

# compile/install QuEST
RUN \
    apt-get -y install $QUEST_BUILT_DEPS && \
    cd /opt && \
    git clone https://github.com/quest-kit/QuEST.git && \
    cd /opt/QuEST && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . && \
    mkdir /usr/local/QuEST && \
    mkdir /usr/local/QuEST/lib && \
    cp QuEST/libQuEST.a /usr/local/QuEST/lib && \
    cp -r ../QuEST/include /usr/local/QuEST/include && \
    rm -rf /opt/QuEST && \
    apt-get -y remove $QUEST_BUILT_DEPS && \
    apt-get -y autoremove

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
"

RUN \
    apt-get -y install $JELLYFISH_BUILT_DEPS && \
    cd /opt && \
    git clone https://github.com/FabianLangkabel/Jellyfish.git && \
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
    apt-get -y autoremove

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
    apt-get -y install $JELLYFISH_RUNTIME_DEPS --no-install-recommends

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
