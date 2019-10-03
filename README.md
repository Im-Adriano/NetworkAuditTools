# NetworkAuditTools
Tools created for Lab 3 in Network &amp; Security Audit class.

<h1>DNS Enumeration</h1>

The DNS Enumeration script (written in Powershell) is a quick and easy script that
takes in a .txt file with a list of domain names and attempts to resolve the IPs
from that list.

<h1>OS Detection</h1>

The OS Detection script (written in bash) tries to determine remote host OS based 
off of TTL values in ping responses. Takes in a .txt file of IPs to run against, 
with a different IP on each line. 

<h1>Ping Sweep</h1>

The Ping Sweep tool takes in an ip range formatted like '192.168.0.0/24' or '192.168.1.1-192.168.2.255' as a command line argument. Prints out what hosts respond to the ping.

<h1>Port Scan</h1>

The port scan tool takes a range of IP addresses, in the format '192.168.0.0/24' or '192.168.1.1-192.168.2.255', or a single IP address as the first arguement. The second arguement takes a range of ports, in the format '1-80' or 20,21,22, or a single port. The program will then print out all open ports and IP addresses

<h1>Arp Scanner</h1>

The Arp Scanner tool takes in a interface name to scan for clients on. It determines the IP of this interface and sends ARP request messages to get the MAC address and IP of all hosts on the network. It can help find hosts that were not found with the ping sweep, if they are configured to drop ICMP.
