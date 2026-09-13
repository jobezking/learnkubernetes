# Basic Networking
ip link  #brief view of network interfaces
ip addr  # see ip addresses asssigned to interfaces
ip addr add 192.168.1.10/24 dev eth0  # used to set IP addresses on interfaces
route (or ip route) # displays the kernel's routing table
ip route add 192.168.2.0/24 via 192.168.1.1  # route from one network to another via a router whose ip is 192.168.1.1
ip route add default via 192.168.2.1  # default gateway
cat /proc/sys/net/ipv4/ip_forward
# Basic DNS
/etc/resolv.conf  # contains address of DNS server
A: IP to hostname
AAAA: hostname to IPv6
CNAME: mapping one DNS name to another
ping
nslookup
dig
# network namespaces: create 2, one named red and the other blue
ip netns add red
ip netns add blue