#! /bin/sh -ve

DIR=~/ovs/utilities

# For this test we will pre-populate ARP caches at the end-hosts

$DIR/ovs-ofctl --protocols=OpenFlow15 del-flows br0

# Verify Checksum (Table 0)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=0,priority=32768,dl_type=0x800 \
						                            actions=resubmit(,1)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=0,priority=0 actions="

# IPv4 LPM (Table 1)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=32768,ip,nw_dst=10.0.0.15/24 \
                                                    actions=set_field:0x0B00000F->reg0, \
                                                            set_field:2->reg1, \
                                                            dec_ttl, \
                                                            resubmit(,2)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=32768,ip,nw_dst=20.0.0.17/24 \
                                                    actions=set_field:0x15000011->reg0, \
                                                            set_field:5->reg1, \
                                                            dec_ttl, \
                                                            resubmit(,2)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=32768,ip,nw_dst=30.0.0.19/24 \
                                                    actions=set_field:0x1F000013->reg0, \
                                                            set_field:6->reg1, \
                                                            dec_ttl, \
                                                            resubmit(,2)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=1,priority=0 actions="

# Forward (Table 2)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=32768,reg0=0x0B00000F \
                                                    actions=set_field:11:11:12:13:14:15->dl_dst, \
                                                            resubmit(,3)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=32768,reg0=0x15000011 \
                                                    actions=set_field:11:11:12:13:14:17->dl_dst, \
                                                            resubmit(,3)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=32768,reg0=0x1F000013 \
                                                    actions=set_field:11:11:12:13:14:19->dl_dst, \
                                                            resubmit(,3)"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=2,priority=0 actions="

# Send Frame (Table 3)
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=3,priority=32768,reg1=2 \
                                                    actions=set_field:11:11:12:13:14:14->dl_src, \
                                                            output:NXM_NX_REG1[]"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=3,priority=32768,reg1=5 \
                                                    actions=set_field:11:11:12:13:14:16->dl_src, \
							                                output:NXM_NX_REG1[]"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=3,priority=32768,reg1=6 \
                                                    actions=set_field:11:11:12:13:14:18->dl_src, \
							                                output:NXM_NX_REG1[]"
$DIR/ovs-ofctl --protocols=OpenFlow15 add-flow br0 "table=3,priority=0 actions="

# Setting Hosts
# ip addr add 172.28.129.10/24 dev eth1
# ip route add default via 172.28.129.1 dev eth1
# arp -s 172.28.129.1 08:00:27:13:6c:ef # (Setting permanent ARP entry)
