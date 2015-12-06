#!/bin/bash

# Setup Environment
cd ../setup-scripts
source ./helpers/setup-vars-ovs-dpdk.sh

# Profile
cd ..
operf -g ./vswitchd/ovs-vswitchd --dpdk -c 0x1 -n 4 -- unix:$DB_SOCK --pidfile

mkdir -p ./oprofile_data/opreport

# Generate png with and without call-graph 
opreport -cgf | gprof2dot -f oprofile | dot -Tpng -o ./oprofile_data/opreport/stats.png

# Generate diff
if [ -d "./oprofile_data/oparchive/previous" ]; then
	mkdir -p ./oprofile_data/oparchive/previous
	opreport --session-dir=`pwd`/oprofile_data/ -xlg ./vswitchd/ovs-vswitchd { archive:./oprofile_data/oparchive/previous } { } > ./oprofile_data/opreport/stats.diff
fi

# Archive
oparchive -o ./oprofile_data/oparchive/previous ./vswitchd/ovs-vswitchd

cd ./vswitchd