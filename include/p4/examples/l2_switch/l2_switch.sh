#! /bin/sh -ve

DIR=~/ovs/utilities

$DIR/ovs-ofctl --protocols=OpenFlow15 del-flows br0

# SMAC Table 0
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=0,priority=32768,ethernet__srcAddr=0xf8bc120ab5e0 actions=resubmit(,1)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=0,priority=32768,ethernet__srcAddr=0x3cfdfe05b9c0 actions=resubmit(,1)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=0,priority=0                                      actions=controller"

# DMAC Table 1
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=32768,ethernet__dstAddr=0xf8bc120ab5e0 actions=set_field:1->reg0,resubmit(,2)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=32768,ethernet__dstAddr=0x3cfdfe05b9c0  actions=set_field:2->reg0,resubmit(,2)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=0                                      actions=flood"

# SRC Pruning Table 2
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=32768,in_port=1,reg0=1 actions="
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=32768,in_port=2,reg0=2 actions="
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=0                                               actions=output:NXM_NX_REG0[]"