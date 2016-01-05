
parser start {
    return parse_ethernet;
}

header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header ethernet_t ethernet_;

parser parse_ethernet {
    extract(ethernet_);
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