#!/bin/bash

# Setup Environment
cd ../setup-scripts
source ./helpers/setup-vars-ovs-dpdk.sh

# Profile
cd ..
operf -g ./vswitchd/ovs-vswitchd --dpdk -c 0x1 -n 4 -- unix:$DB_SOCK --pidfile

# Generate png
opreport -cgf | gprof2dot -f oprofile | dot -Tpng -o opreport.png

# Generate diff
if [ -d "./oparchive-previous" ]; then
	opreport --session-dir=`pwd`/oprofile_data/ -xlg ./vswitchd/ovs-vswitchd { archive:./oparchive-previous } { } > oparchive.stats
fi

# Archive
oparchive -o ./oparchive-previous ./vswitchd/ovs-vswitchd

cd ./vswitchd