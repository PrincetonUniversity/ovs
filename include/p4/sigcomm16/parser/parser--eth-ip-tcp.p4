
header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}

header_type tcp_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        seqNo : 32;
        ackNo : 32;
        dataOffset : 4;
        res : 4;
        flags : 8;
        window : 16;
        checksum : 16;
        urgentPtr : 16;
    }
}

header ethernet_t ethernet_;
header ipv4_t ipv4_;
header tcp_t tcp_;

#define ETHERTYPE_IPV4 0x0800
#define IP_PROTOCOLS_IPHL_TCP 0x506

parser start {
    return parse_ethernet;
}

parser parse_ethernet {
    extract(ethernet_);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

parser parse_ipv4 {
    extract(ipv4_);
    return select(latest.fragOffset, latest.ihl, latest.protocol) {
        IP_PROTOCOLS_IPHL_TCP : parse_tcp;
        default: ingress;
    }
}

parser parse_tcp {
    extract(tcp_);
    return ingress;
}

//---------------------------//

action _nop() {
}

table dummy {
    reads { standard_metadata.egress_spec : exact; }
    actions { _nop; }
    size : 1;
}

control ingress {
    apply(dummy);
}
