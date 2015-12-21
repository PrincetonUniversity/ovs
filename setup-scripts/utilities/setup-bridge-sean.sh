#! /bin/sh -ve

DIR=/home/ubuntu/ovs/utilities

$DIR/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
$DIR/ovs-vsctl set bridge br0 protocols=OpenFlow15

$DIR/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk
$DIR/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk

$DIR/ovs-ofctl --protocols=OpenFlow15 del-flows br0
