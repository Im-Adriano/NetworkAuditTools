#!/bin/bash

windowsTTL=128
linuxTTL=64

while read p; do
    numHops=$(traceroute -I ${p} | awk 'END{print $1}')
    pingCmd=$(ping -v -w 5 -c 1 ${p})
    ttlFromPing=$(echo $pingCmd | awk -Fttl= '{print $2}' | awk '{print $1}' | sort -rn | head -n 1) 
    if [[ ! -z $ttlFromPing && ! -z $numHops ]]; then   
        guessTtl="$(($numHops+$ttlFromPing))"
        distToWinTTL="$(($windowsTTL-$guessTtl))"
        distToLinuxTTL="$(($linuxTTL-$guessTtl))"
        
        if [[ ${distToLinuxTTL#-} -lt ${distToWinTTL#-} ]]; then
            echo "$p is probably a Linux host"
        else
            echo "$p is probably a Windows host"
        fi
    else
        reachable=$(echo "$pingCmd" | awk 'FNR==2')
        if [[ $reachable != *"Destination Host Unreachable"* ]]; then
            echo "$p might be Windows (host is up but ICMP is being filtered)"
        fi
    fi
done < $1
