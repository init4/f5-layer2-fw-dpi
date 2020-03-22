# F5 TMOS Virtual Edition - SRIoV - Layer 2 transparent Firewall & DPI 

## Hardware

[Supermicro E200-8D](https://www.supermicro.com/en/products/system/Mini-ITX/SYS-E200-8D.cfm)

| Component     | Model         | 
| ------------- |:-------------:| 
| CPU | Intel® Xeon™ CPU D-1528 Processor | 
| RAM | 2x 8GB, DDR4, 2133MHz |
| Storage | Samsung SSD 970 EVO Plus 500GB M.2 Internal Solid State Drive |
| Network | 2x 1G Intel (eno1/eno2), 2x 10G Intel (eno3/eno4), 1x Realtek LOM ||

Todo: Photo

## Hypervisor

Debian 9/stretch & KVM:
`root@skywarp:/home/john# dpkg -l |grep kvm
ii  qemu-kvm                             1:2.8+dfsg-6+deb9u9               amd64        QEMU Full virtualization on x86 hardware
root@skywarp:/home/john# 
root@skywarp:/home/john# kvm -version
QEMU emulator version 2.8.1(Debian 1:2.8+dfsg-6+deb9u9)
Copyright (c) 2003-2016 Fabrice Bellard and the QEMU Project developers
root@skywarp:/home/john# `

## Topology 

Below is a simple diagram of how the device is physically connected:
`
+-------------------+           +-------------------+           +-------------------+ 
|                   |           | TMOS VE           |           |                   | 
| Juniper BNG MAC   |        1.2| 1.1 MAC           |1.1        | NetBSD router MAC | 
| 4c:16:fc:2f:08:85 |===========| ac:1f:6b:1d:c4:8a |===========| bcmeth1           |
|                   |       4093| 1.2 MAC           |4094       | 6c:70:9f:d0:91:a2 | 
|                   |   External| ac:1f:6b:1d:c4:8b |Internal   |                   | 
+-------------------+           +-------------------+           +-------------------+

                     <---- vlangroup1 MAC ae:1f:6b:1d:c4:8b ---->
`

## Software
#### Linux
Debian 9 with a very basic KVM configuration.

#### Linux configuratino
Guest was created with the following:
`
virt-install --virt-type=kvm --name shrapnel --ram 8192 --vcpus=4 --os-variant=rhel6 --hvm --boot=hd \
--network=bridge=privatebr0,model=virtio \
--host-device=pci_0000_05_00_0 \
--host-device=pci_0000_05_00_1 \
--graphics vnc \
--disk path=/scratch/vm/shrapnel/BIGIP-15.1.0.1-0.0.4.qcow2,bus=virtio,format=qcow2
` 

#### TMOS 
Currently using latest TMOS 15.1, with SRIOV/PCI passthru.

`
Sys::Version
Main Package
  Product     BIG-IP
  Version     15.1.0.1
  Build       0.0.4
  Edition     Point Release 1
  Date        Fri Jan 10 12:55:21 PST 2020
`

#### TMOS configuration
See shrapnel.scf for detailed TMOS configuration info.

## Todo

- Performance graphs
- More info on the DPI stuff
 


