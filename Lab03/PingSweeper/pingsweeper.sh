#!/bin/bash

main() {
    pingTimeout=0.1
    rangeIdx=$(expr index $1 '-')
    subnetIdx=$(expr index $1 '/')
    if [ $rangeIdx -ne 0 ] && [ $subnetIdx -ne 0 ]; then
        echo "unrecognized format"
    elif [ $rangeIdx -ne 0 ]; then
        # echo "range"
        ips=($(awk -F- '{$1=$1} 1' <<<"$1"))
        ip0=($(awk -F. '{$1=$1} 1' <<<"${ips[0]}"))
        ip1=($(awk -F. '{$1=$1} 1' <<<"${ips[1]}"))
        ip0=$(( (${ip0[0]} << 24) | (${ip0[1]} << 16) | (${ip0[2]} << 8) | ${ip0[3]} ))
        ip1=$(( (${ip1[0]} << 24) | (${ip1[1]} << 16) | (${ip1[2]} << 8) | ${ip1[3]} ))
        for ip in $(seq $ip0 $ip1); do
            # echo $ip
            o1=$(( ( $ip >> 24 ) & 255 ))
            o2=$(( ( $ip >> 16 ) & 255 ))
            o3=$(( ( $ip >> 8  ) & 255 ))
            o4=$(( $ip & 255 ))
            IP="$o1.$o2.$o3.$o4"
            timeout $pingTimeout ping -c 1 $IP >/dev/null 2>&1 && echo $IP
        done
    elif [ $subnetIdx -ne 0 ]; then
        # echo "subnet"
        ips=($(awk -F/ '{$1=$1} 1' <<<"$1"))
        network=${ips[0]}
        maskbit=${ips[1]}
        network=($(awk -F. '{$1=$1} 1' <<<"$network"))
        network=$(( (${network[0]} << 24) | (${network[1]} << 16) | (${network[2]} << 8) | ${network[3]} ))
        # echo $network
        endip=$(( $network | ( ( 1 << (32 - $maskbit) ) - 1 ) ))
        for ip in $(seq $network $endip); do
            # echo $ip
            o1=$(( ( $ip >> 24 ) & 255 ))
            o2=$(( ( $ip >> 16 ) & 255 ))
            o3=$(( ( $ip >> 8  ) & 255 ))
            o4=$(( $ip & 255 ))
            IP="$o1.$o2.$o3.$o4"
            # echo $IP
            timeout $pingTimeout ping -c 1 $IP >/dev/null 2>&1 && echo $IP
        done
    else
        echo "unrecognized format"
    fi
}

main $@
