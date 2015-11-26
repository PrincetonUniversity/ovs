## P4 -> OVS

Here are some instructions on how to test this with P4:

### Installing P4 behavioral model and OVS:

* Clone my local fork of the p4c-behavioral repo ...

``` bash
$ git clone https://github.com/PrincetonUniversity/p4c-behavioral.git
```

* Checkout ovs branch ...

``` bash
$ git checkout ovs
```

* Install it using the instructions here ...

https://github.com/PrincetonUniversity/p4c-behavioral/blob/ovs/README.md

* Now clone the local fork for OVS from here ...

``` bash
$ git clone https://github.com/PrincetonUniversity/ovs.git
``` 

* Checkout p4 branch ...

``` bash
$ git checkout p4
```

### Compiling OVS with P4:

``` bash
$ cd <ovs-root-dir>
$ ./boot.sh
$ ./configure --with-dpdk=$DPDK_BUILD CFLAGS="-g -O2 -Wno-cast-align" p4inputfile=<p4-program> p4outputdir=/root/ovs/include/p4/src
$ make clean
$ make
```

### Example: l2_switch.p4

* Compiling the program:

``` bash
$ cd <ovs-root-dir>
$ ./boot.sh
$ ./configure --with-dpdk=$DPDK_BUILD CFLAGS="-g -O2 -Wno-cast-align" p4inputfile=<ovs-root-dir>/include/p4/examples/l2_switch/l2_switch.p4 p4outputdir=/root/ovs/include/p4/src
$ make clean
$ make
```

* Install static flow rules:

$ cd <ovs-root-dir>/include/p4/examples/l2_switch
$ ./l2_switch.sh

### Other

* P4 Workshop demo setup: https://goo.gl/ipUeen
