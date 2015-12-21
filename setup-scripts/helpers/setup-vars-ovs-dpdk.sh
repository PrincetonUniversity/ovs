export RTE_SDK=$PWD/../deps/dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc

export DPDK_DIR=$RTE_SDK
export DPDK_BUILD=$DPDK_DIR/$RTE_TARGET/
export DB_SOCK=/usr/local/var/run/openvswitch/db.sock
