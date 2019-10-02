#!/bin/bash

ips=()
if [[ ! $1 =~ '-' ]]; then
  ipAndSubnet=(${1//\// })
  
  ip=(${ipAndSubnet[0]//./ })
  subnet=${ipAndSubnet[1]}


  if [[ $((8-${subnet})) -gt 0 ]]; then
    netmask=($((256-2**(8-${subnet}))) 0 0 0)
  elif  [[ $((16-${subnet})) -gt 0 ]]; then
    netmask=(255 $((256-2**(16-${subnet}))) 0 0)
  elif  [[ $((24-${subnet})) -gt 0 ]]; then
    netmask=(255 255 $((256-2**(24-${subnet}))) 0)
  elif [[ $((32-${subnet})) -gt 0 ]]; then 
    netmask=(255 255 255 $((256-2**(32-${subnet}))))
  fi

  for i in $(seq 0 $((255-${netmask[0]}))); do
    for j in $(seq 0 $((255-${netmask[1]}))); do
      for k in $(seq 0 $((255-${netmask[2]}))); do
        for l in $(seq 1 $((255-${netmask[3]}))); do
          firstQuad=$(($i+$((${ip[0]} & ${netmask[0]}))))
          secondQuad=$(($j+$((${ip[1]} & ${netmask[1]}))))
          thirdQuad=$(($k+$((${ip[2]} & ${netmask[2]}))))
          fourthQuad=$(($l+$((${ip[3]} & ${netmask[3]}))))

          ips+=( $firstQuad"."$secondQuad"."$thirdQuad"."$fourthQuad )
        done
      done
    done
  done
else
  range=(${1//-/ })

  ip1=(${range[0]//./ })
  ip2=(${range[1]//./ })

  if [[ ${ip1[0]} -gt ${ip2[0]} || ${ip1[1]} -gt ${ip2[1]} || ${ip1[2]} -gt ${ip2[2]} || ${ip1[3]} -gt ${ip2[3]} ]]; then
    echo "Ip range not valid"
    exit
  fi

  for i in $(seq ${ip1[0]} ${ip2[0]}); do
    for j in $(seq ${ip1[1]} ${ip2[1]}); do
      for k in $(seq ${ip1[2]} ${ip2[2]}); do
        for l in $(seq ${ip1[3]} ${ip2[3]}); do
          ips+=( "$i.$j.$k.$l" )
        done
      done
    done
  done
fi


for i in ${ips[@]}
do
  ping=$(ping -v -w 1 -c 1 ${i})
  if [[ $? -eq 0 ]]; then
    echo "${i} responded to ping"
  fi
done
