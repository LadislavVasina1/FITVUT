#!/bin/sh

sleepDurationSeconds=$1

previousStats=$(cat /proc/stat | head -n1)

sleep $sleepDurationSeconds

currentStats=$(cat /proc/stat | head -n1)

    user=$(echo "$currentStats" | awk -F " " '{print $2}')
    nice=$(echo "$currentStats" | awk -F " " '{print $3}')
    system=$(echo "$currentStats" | awk -F " " '{print $4}')
    idle=$(echo "$currentStats" | awk -F " " '{print $5}')
    iowait=$(echo "$currentStats" | awk -F " " '{print $6}')
    irq=$(echo "$currentStats" | awk -F " " '{print $7}')
    softirq=$(echo "$currentStats" | awk -F " " '{print $8}')
    steal=$(echo "$currentStats" | awk -F " " '{print $9}')
    guest=$(echo "$currentStats" | awk -F " " '{print $10}')
    guest_nice=$(echo "$currentStats" | awk -F " " '{print $11}')

    prevuser=$(echo "$previousStats" | awk -F " " '{print $2}')
    prevnice=$(echo "$previousStats" | awk -F " " '{print $3}')
    prevsystem=$(echo "$previousStats" | awk -F " " '{print $4}')
    previdle=$(echo "$previousStats" | awk -F " " '{print $5}')
    previowait=$(echo "$previousStats" | awk -F " " '{print $6}')
    previrq=$(echo "$previousStats" | awk -F " " '{print $7}')
    prevsoftirq=$(echo "$previousStats" | awk -F " " '{print $8}')
    prevsteal=$(echo "$previousStats" | awk -F " " '{print $9}')
    prevguest=$(echo "$previousStats" | awk -F " " '{print $10}')
    prevguest_nice=$(echo "$previousStats" | awk -F " " '{print $11}')

    echo "currentStats: $currentStats"
    echo "previousStats: $previousStats"
    echo ""

    echo "user: $user"
    echo "prevuser: $prevuser"
    echo "nice: $nice"
    echo "prevnice: $prevnice"
    echo "system: $system"
    echo "prevsystem: $prevsystem"
    echo "idle: $idle"
    echo "previdle: $previdle"
    echo "iowait: $iowait"
    echo "previowait: $previowait"
    echo "irq: $irq"
    echo "previrq: $previrq"
    echo "prevsoftirq: $prevsoftirq"
    echo "softirq: $softirq"
    echo "steal: $steal"
    echo "prevsteal: $prevsteal"
    echo "guest: $guest"
    echo "prevguest: $prevguest"
    echo "guest_nice: $guest_nice"
    echo "prevguest_nice: $prevguest_nice"
    echo ""

    PrevIdle=$((previdle + previowait))
    Idle=$((idle + iowait))
    PrevNonIdle=$((prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal))
    NonIdle=$((user + nice + system + irq + softirq + steal))
    PrevTotal=$((PrevIdle + PrevNonIdle))
    Total=$((Idle + NonIdle))
    totald=$((Total - PrevTotal))
    idled=$((Idle - PrevIdle))

    echo "PrevIdle: $PrevIdle"
    echo "Idle: $Idle"
    echo "PrevNonIdle: $PrevNonIdle"
    echo "NonIdle: $NonIdle"
    echo "PrevTotal: $PrevTotal"
    echo "Total: $Total"
    echo ""

    echo "totald: $totald"
    echo "idled: $idled"
    CPU_Percentage=$(awk "BEGIN {print ($totald - $idled)/$totald*100}")
    echo "CPU LOAD: $CPU_Percentage %"
    exit
