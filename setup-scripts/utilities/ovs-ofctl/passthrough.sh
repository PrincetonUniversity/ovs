#! /bin/sh -ve

DIR=~/ovs/utilities

$DIR/ovs-ofctl --protocols=OpenFlow15 del-flows br0

$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=1, actions=2"
#$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=3, actions=5"
#$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=4, actions=6"
#$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=2, actions=1"
#$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=5, actions=3"
#$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=6, actions=4"
