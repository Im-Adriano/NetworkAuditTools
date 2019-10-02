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
