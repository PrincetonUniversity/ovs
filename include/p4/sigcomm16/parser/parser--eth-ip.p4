
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

header ethernet_t ethernet_;
header ipv4_t ipv4_;

#define ETHERTYPE_IPV4 0x0800

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
