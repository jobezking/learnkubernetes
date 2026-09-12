ip link  #brief view of network interfaces
ip addr  # see ip addresses asssigned to interfaces
ip addr add 192.168.1.10/24 dev eth0  # used to set IP addresses on interfaces
route (or ip route) # displays the kernel's routing table
ip route add 192.168.2.0/24 via 192.168.1.1  # route from one network to another via a router whose ip is 192.168.1.1
ip route add default via 192.168.2.1  # default gateway
cat /proc/sys/net/ipv4/ip_forward