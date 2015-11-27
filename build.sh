#!/bin/bash

# TODO: this should probably be a makefile
# TODO: install target
(
# Compile dpdk
if [ ! -d "./dpdk" ]; then
echo "./dpdk doesn't exist"
exit 1
fi
cd ./dpdk
make -j 8 install T=x86_64-native-linuxapp-gcc

# Compile ovs
cd ../setup-scripts
source ./helpers/setup-vars-ovs-dpdk.sh
cd ../
./boot.sh
./configure --with-dpdk=$DPDK_BUILD CFLAGS="-g -O2 -Wno-cast-align" \
            p4inputfile=../p4c-behavioral/tests/l2_switch.p4 \
            p4outputdir=/root/ovs/include/p4/src
make clean
make -j 8
)
