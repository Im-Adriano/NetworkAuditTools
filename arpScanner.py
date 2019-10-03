import socket
import sys
from struct import pack
import fcntl
import ipaddress

def get_ip_and_mask(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    ip = socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        35093, 
        pack('256s', ifname[:15].encode('utf-8'))
        )[20:24])
    netmask = socket.inet_ntoa(fcntl.ioctl(
        s.fileno(), 
        35099, 
        pack('256s', ifname[:15].encode('utf-8'))
        )[20:24])
    mac = fcntl.ioctl(s.fileno(),
        35111,  
        pack('256s', ifname[:15].encode('utf-8'))
        )[18:24]
    return ip, netmask, mac


s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(3))
s.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 1024)
s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
s.bind((sys.argv[1], 0))
s.settimeout(.1)

localIP, netmask, mac = get_ip_and_mask(sys.argv[1])
net = ipaddress.ip_network(localIP+'/'+netmask, strict=False)
localIP = socket.inet_aton(str(localIP))

for ip in ipaddress.IPv4Network(net):
    ip = socket.inet_aton(str(ip))

    ARP_FRAME = [
        pack('!6B', *(0xFF,)*6),    # Dest Addr
        pack('!6B', *mac),          # Src Addr
        pack('!2B', *(0x08, 0x06)), # Type
        pack('!2B', *(0x00, 0x01)), # Hdwr Type
        pack('!2B', *(0x08, 0x00)), # Proto Type
        pack('!1B', *(0x06,)),      # Addr Len 
        pack('!1B', *(0x04,)),      # Proto Len
        pack('!2B', *(0x00, 0x01)), # OP code
        pack('!6B', *mac),          # Sender Hdwr Addr
        pack('!4B', *localIP),      # Sender IP Addr
        pack('!6B', *(0x00,)*6),    # Target Hdwr Addr
        pack('!4B', *ip)            # Target IP Addr
    ]

    s.send(b''.join(ARP_FRAME))

    try:
        ret = s.recv(1024)
        if ret[12:14] == b'\x08\x06' and ret[20:22] == b'\x00\x02':
            foundIP = ipaddress.IPv4Address(ret[28:32])
            foundMAC = ':'.join('%02x' % b for b in ret[22:28]).upper()
            print(f'{foundIP} found at {foundMAC}')
    except socket.timeout:
        pass
 

