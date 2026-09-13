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
ip netns exec red iplink # run iplink inside red namespace
ip -n red link  #see above
ip link add veth-red type veth peer name veth-blue # connectivity from red to blue namespace
ip link set veth-red netns red   # create veth-red interface for red namespace
ip link set veth-blue netns blue # create veth-blue interface for blue namespace
ip -n red addr add 192.168.15.1 dev veth-red  # add IP address to veth-red interface in red ns
ip -n blue addr add 192.168.15.2 dev veth-blue  # add IP address to veth-red interface in red ns
ip -n red link set veth-red up      #activate interface
ip -n blue link set veth-blue up    #activate interface
ip netns exec red ping 192.168.15.2
ip netns exec red arp
ip netns exec blue arp
ip -n red link del veth-red    # delete because namespace to namespace links inefficient. will use switch instead
ip -n red link del veth-blue   # delete because namespace to namespace links inefficient. will use switch instead

# create virtual switch
ip link add v-net-0 type bridge
ip link set dev v-net-0 up
ip link add veth-red type veth peer name veth-red-br
ip link add veth-blue type veth peer name veth-blue-br
ip link set veth-red netns red
ip link set veth-red-br master v-net-0
ip link set veth-blue netns blue
ip link set veth-blue-br master v-net-0
ip -n red addr add 192.168.15.1 dev veth-red
ip -n blue addr add 192.168.15.2 dev veth-blue
ip -n red link set veth-red up
ip -n blue link set veth-blue up
ip addr add 192.168.15.5/24 dev v-net-0  # add connectivity from host to virtual switch

docker network ls