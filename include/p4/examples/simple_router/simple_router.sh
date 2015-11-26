#! /bin/sh -ve

DIR=~/ovs/utilities

# For this test we will pre-populate ARP caches at the end-hosts

$DIR/ovs-ofctl --protocols=OpenFlow15 del-flows br0

# Verify Checksum (Table 0)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=0,priority=32768,ethernet__etherType=0x800 \
						    actions=calc_fields_verify(ipv4__hdrChecksum,csum16,fields:ipv4__version_ihl,ipv4__diffserv,ipv4__totalLen,ipv4__identification,ipv4__flags_fragOffset,ipv4__ttl,ipv4__protocol,ipv4__srcAddr,ipv4__dstAddr), \
                                                            resubmit(,1)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=0,priority=0 actions="

# IPv4 LPM (Table 1)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=32768,ipv4__dstAddr=0xC0A80001/0xFFFFFF00 \
                                                    actions=set_field:0xAC1E82D9->routing_metadata_nhop_ipv4, \
                                                            set_field:1->reg0, \
                                                            set_field:63->ipv4__ttl, \
                                                            resubmit(,2)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=32768,ipv4__dstAddr=0xC0A80101/0xFFFFFF00 \
                                                    actions=set_field:0xAC1F83DA->routing_metadata_nhop_ipv4, \
                                                            set_field:2->reg0, \
                                                            set_field:63->ipv4__ttl, \
                                                            resubmit(,2)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=0 actions="

# Forward (Table 2)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=32768,routing_metadata_nhop_ipv4=0xAC1E82D9 \
                                                    actions=set_field:0xf8bc120ab5e0->ethernet__dstAddr, \
                                                            resubmit(,3)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=32768,routing_metadata_nhop_ipv4=0xAC1F83DA \
                                                    actions=set_field:0x3cfdfe05b9c0->ethernet__dstAddr, \
                                                            resubmit(,3)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=0 actions="

# Send Frame (Table 3)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=3,priority=32768,reg0=1 \
                                                    actions=set_field:0xf8bc120ab5e0->ethernet__srcAddr, \
							    calc_fields_update(ipv4__hdrChecksum,csum16,fields:ipv4__version_ihl,ipv4__diffserv,ipv4__totalLen,ipv4__identification,ipv4__flags_fragOffset,ipv4__ttl,ipv4__protocol,ipv4__srcAddr,ipv4__dstAddr), \
                                                            deparse, \
                                                            output:NXM_NX_REG0[]"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=3,priority=32768,reg0=2 \
                                                    actions=set_field:0x3cfdfe05b9c0->ethernet__srcAddr, \
							    calc_fields_update(ipv4__hdrChecksum,csum16,fields:ipv4__version_ihl,ipv4__diffserv,ipv4__totalLen,ipv4__identification,ipv4__flags_fragOffset,ipv4__ttl,ipv4__protocol,ipv4__srcAddr,ipv4__dstAddr), \
                                                            deparse, \
                                                            output:NXM_NX_REG0[]"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=3,priority=0 actions="

# Setting Hosts
# ip addr add 172.28.129.10/24 dev eth1
# ip route add default via 172.28.129.1 dev eth1
# arp -s 172.28.129.1 08:00:27:13:6c:ef # (Setting permanent ARP entry)