#!/bin/bash

# TODO: this should probably be a makefile
# TODO: install target
(
cd deps/dpdk
if [[ ! -e Makefile ]]
then
	echo "ERROR: dpdk submodule not initialized"
	echo "Please run git submodule update --init"
	exit 1
fi
patch -p1 -N < ../../setup-scripts/patches/dpdk-config.patch
make -j 8 install T=x86_64-native-linuxapp-gcc
cd ../../
cd setup-scripts
source ./helpers/setup-vars-ovs-dpdk.sh
cd ../
./boot.sh
./configure --with-dpdk=$DPDK_BUILD CFLAGS="-g -O2 -Wno-cast-align" \
            p4inputfile=/home/ubuntu/p4c-behavioral/tests/simple_router.p4 \
            p4outputdir=./include/p4/src
make clean
make -j 8
)
