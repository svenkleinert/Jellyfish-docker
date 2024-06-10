FROM debian:latest

ARG VTK_VERSION=9.3.0
ARG QUEST_VERSION=3.7.0

RUN \
    apt update  && \
    apt install -y cmake git g++ make libopenblas-dev libzip-dev qt6-base-dev qt6-charts-dev wget

# compile/install libcint
RUN \
    cd /opt && \
    git clone http://github.com/sunqm/libcint.git && \
    cd /opt/libcint && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/libcint -DBUILD_SHARED_LIBS=0 -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . --target install && \
    rm -r /opt/libcint

# compile/install muparser
RUN \
    cd /opt && \
    git clone https://github.com/beltoforion/muparser.git && \
    cd /opt/muparser && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/muparser -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . --target install && \
    rm -r /opt/muparser

# download eigen
RUN \
    cd /usr/local && \
    git clone https://gitlab.com/libeigen/eigen.git

# compile/install vtk
RUN \
    cd /opt && \
    wget -q https://www.vtk.org/files/release/${VTK_VERSION%.*}/VTK-$VTK_VERSION.tar.gz && \
    tar -xvzf VTK-$VTK_VERSION.tar.gz && \
    cd /opt/VTK-$VTK_VERSION && \
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
    rm -rf /opt/VTK-$VTK_VERSION && \
    rm -rf /opt/VTK-$VTK_VERSION.tar.gz
#
# compile/install QuEST
RUN \
    cd /opt && \
    git clone https://github.com/quest-kit/QuEST.git && \
    cd /opt/QuEST && \
    git checkout v$QUEST_VERSION && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. && \
    cmake --build . && \
    mkdir /usr/local/QuEST && \
    mkdir /usr/local/QuEST/lib && \
    cp QuEST/libQuEST.a /usr/local/QuEST/lib && \
    cp -r ../QuEST/include /usr/local/QuEST/include && \
    rm -rf /opt/QuEST
