#!/bin/bash

main() {
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
            ping -c 1 $IP >/dev/null 2>&1
            if [ $? -eq "0" ]; then
                echo $IP
            fi
        done
    elif [ $subnetIdx -ne 0 ]; then
        # echo "subnet"
    else
        echo "unrecognized format"
    fi
}

main $@
