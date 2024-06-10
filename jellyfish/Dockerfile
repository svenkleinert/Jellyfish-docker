FROM svenkleinert/jellyfish-build:latest

# clone and compile jellyfish
RUN \
    cd /usr/local/ && \
    git clone https://github.com/FabianLangkabel/Jellyfish.git && \
    cd /usr/local/Jellyfish && \
    mkdir build && \
    cd /usr/local/Jellyfish/build && \
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
    cp Plugins/QuantumComputing/libQuantumComputing.so JellyfishCMD/Plugins

# create possible entrypoints
RUN \
    echo '#!/bin/bash\n \
    cd /usr/local/Jellyfish/build/JellyfishGUI/\n \
    ./JellyfishGUI \
    ' > /usr/local/bin/JellyfishGUI && \
    chmod +x /usr/local/bin/JellyfishGUI

RUN \
    echo '#!/bin/bash\n \
    cd /usr/local/Jellyfish/build/JellyfishCMD/\n \
    ./JellyfishCMD \
    ' > /usr/local/bin/JellyfishCMD && \
    chmod +x /usr/local/bin/JellyfishCMD

ENTRYPOINT ["/usr/local/bin/JellyfishGUI"]
