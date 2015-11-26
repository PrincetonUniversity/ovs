p4ovsincludedir = $(includedir)/p4
p4ovsinclude_HEADERS = \
	include/p4/src/ovs_match_dp_packet.h \
	include/p4/src/ovs_match_enum.h \
	include/p4/src/ovs_match_flow.h \
	include/p4/src/ovs_match_match.h \
	include/p4/src/ovs_match_meta_flow.h \
	include/p4/src/ovs_match_nx_match.h \
	include/p4/src/ovs_match_odp_execute.h \
	include/p4/src/ovs_match_odp_util.h \
	include/p4/src/ovs_match_ofproto_dpif_sflow.h \
	include/p4/src/ovs_match_openvswitch.h \
	include/p4/src/ovs_match_packets.h \
	include/p4/src/ovs_action_type.h \
	include/p4/src/ovs_action_dpif.h \
	include/p4/src/ovs_action_dpif_netdev.h \
	include/p4/src/ovs_action_odp_execute.h \
	include/p4/src/ovs_action_odp_util.h \
	include/p4/src/ovs_action_ofp_actions.h \
	include/p4/src/ovs_action_ofproto_dpif_sflow.h \
	include/p4/src/ovs_action_ofproto_dpif_xlate.h \
	include/p4/src/ovs_action_openvswitch.h \
	include/p4/src/ovs_action_packets.h
	
EXTRA_DIST += include/p4/README.md \
	include/p4/examples/l2_switch/l2_switch.p4 \
	include/p4/examples/l2_switch/l2_switch.sh \
	include/p4/examples/simple_router/simple_router.p4 \
	include/p4/examples/simple_router/simple_router.sh