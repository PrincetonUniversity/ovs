#! /bin/sh -ve

DIR=~/ovs/utilities

$DIR/ovs-ofctl --protocols=OpenFlow15 del-flows br0

$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=1, action=2"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=3, action=5"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=4, action=6"

