#! /bin/sh -ve

DIR=/home/ubuntu/Research/ovs/utilities

$DIR/ovs-ofctl --protocols=OpenFlow15 del-flows br0
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "in_port=1, actions=sub_from_field:2->ethernet__etherType,deparse,output:2"
