#! /bin/sh -ve

DIR=/home/ubuntu/Research/ovs/utilities

$DIR/ovs-ofctl  del-flows br0

# SMAC Table 0
$DIR/ovs-ofctl  add-flow br0 "table=0,priority=32768,ethernet__srcAddr=0x0800276f0f8a actions=resubmit(,1)"
$DIR/ovs-ofctl  add-flow br0 "table=0,priority=32768,ethernet__srcAddr=0x101112131416 actions=resubmit(,1)"
$DIR/ovs-ofctl  add-flow br0 "table=0,priority=32768,ethernet__srcAddr=0x101112131418 actions=resubmit(,1)"
$DIR/ovs-ofctl  add-flow br0 "table=0,priority=0                                      actions=controller"

# DMAC Table 1
$DIR/ovs-ofctl  add-flow br0 "table=1,priority=32768,ethernet__dstAddr=0x08002762b78e actions=set_field:2->reg0,resubmit(,2)"
$DIR/ovs-ofctl  add-flow br0 "table=1,priority=32768,ethernet__dstAddr=0x101112131417 actions=add_to_field:2->nw_ttl,set_field:5->reg0,resubmit(,2)"
$DIR/ovs-ofctl  add-flow br0 "table=1,priority=32768,ethernet__dstAddr=0x101112131419 actions=add_to_field:2->nw_ttl,set_field:6->reg0,resubmit(,2)"
$DIR/ovs-ofctl  add-flow br0 "table=1,priority=0                                      actions=flood"

# SRC Pruning Table 2
$DIR/ovs-ofctl  add-flow br0 "table=2,priority=32768,in_port=1,reg0=1 actions="
$DIR/ovs-ofctl  add-flow br0 "table=2,priority=32768,reg0=2 \
actions=add_to_field:5->ipv4__ttl, \
							    calc_fields_update(ipv4__hdrChecksum,csum16,fields:ipv4__version_ihl,ipv4__diffserv,ipv4__totalLen,ipv4__identification,ipv4__flags_fragOffset,ipv4__ttl,ipv4__protocol,ipv4__srcAddr,ipv4__dstAddr), \
                                                            deparse, \
                                                            output:NXM_NX_REG0[]"
$DIR/ovs-ofctl  add-flow br0 "table=2,priority=32768,in_port=3,reg0=3 actions="
$DIR/ovs-ofctl  add-flow br0 "table=2,priority=32768,in_port=4,reg0=4 actions="
$DIR/ovs-ofctl  add-flow br0 "table=2,priority=32768,in_port=5,reg0=5 actions="
$DIR/ovs-ofctl  add-flow br0 "table=2,priority=32768,in_port=6,reg0=6 actions="
$DIR/ovs-ofctl  add-flow br0 "table=2,priority=0                                               actions=deparse,output:NXM_NX_REG0[]"
