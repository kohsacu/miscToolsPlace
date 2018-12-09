#!/bin/bash

#
# * vcpuinfo - detailed domain vcpu information
#

DOMAIN=${1}
LOOP=${2:-100}
DEBUG=${3:-0}

LCORES=$(lscpu | grep ^"CPU(s):" | awk '{print $2}')

echo "========================================"
echo "Host lCores : ${LCORES}"
echo "Domain(VM)  : ${DOMAIN}"
echo "Loop        : ${LOOP}"
echo "----------------------------------------"

while [ ${LOOP} -gt 0 ]; do
    ARY_VCPU=($(virsh vcpuinfo ${DOMAIN} | grep ^VCPU: | awk '{print $2}' | xargs))
    ARY_CPU=($(virsh vcpuinfo ${DOMAIN} | grep ^CPU: | awk '{print $2}' | xargs))
    ARY_SPEED=($(cat /proc/cpuinfo | grep ^"cpu MHz" | awk '{print $4}' | xargs))

    if [ ${DEBUG} -ne 0 ]; then
        echo "LOOP COUNT: ${LOOP}"
        echo "ARY_VCPU  : ${ARY_VCPU[@]}"
        echo "ARY_CPU   : ${ARY_CPU[@]}"
        echo "ARY_SPEED : ${ARY_SPEED[@]}"
        #echo "ARY_SPEED Num: ${#ARY_SPEED[@]}"
    fi

    for i in $(echo ${ARY_VCPU[@]}); do
        echo "VM CPU: ${i} | Host CPU${ARY_CPU[${i}]}: ${ARY_SPEED[${ARY_CPU[${i}]}]} MHz"
    done
    LOOP=$(( ${LOOP}-1 ))
    echo "----------------------------------------"
    sleep 1
done

echo "========================================"
