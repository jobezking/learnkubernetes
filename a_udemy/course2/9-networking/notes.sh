ip link  #brief view of network interfaces
ip addr add 192.168.1.10/24 dev eth0
route  # displays the kernel's routing table
ip route add 192.168.2.0/24 via 192.168.1.1  # route from one network to another via a router whose ip is 192.168.1.1
ip route add default via 192.168.2.1  # default gateway