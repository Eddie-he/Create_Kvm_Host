#!/bin/bash
# Returns the IP address of a running KVM guest VM
# Assumes a working KVM/libvirt environment
#
# Install:
#   Add this bash function to your ~/.bashrc and `source ~/.bashrc`.
# Usage: 
#   $ virt-addr vm-name
#   192.0.2.16
#
# virt-addr() {
#    VM="$1"
#    arp -an | grep "`virsh dumpxml $VM | grep "mac address" | sed "s/.*'\(.*\)'.*/\1/g"`" | awk '{ gsub(/[\(\)]/,"",$2); print $2 }'
# }

virt-addr() {
    VM="$1"
    search=$( virsh dumpxml $VM | grep "mac address" | sed "s/.*'\(.*\)'.*/\1/g")

    address=$(arp -an | grep "$search" | awk '{ gsub(/[\(\)]/,"",$2); print $2 }')

    if [[ -z "$address" ]]; then
        echo "-"
    else
        echo "$address"
    fi
}

virt-addrs() {
    echo "----------------------------------------------";
    printf "%-30s %s\n" "VM Name" "IP Address";
    virsh -c qemu:///system list --all | grep -o '[0-9]* [a-z]*.*running' | while read -r line;
    do
        #line_cropped=$(echo "$line" | sed 's/[0-9][ ]*\([-._0-9a-zA-Z]*\)[ ]*running/\1/' );
        line_cropped=$(echo "$line" |sed -r 's/([-]|[0-9]+)[ ]+([-._0-9a-zA-Z]*)[ ]+(running|shut off)/\2/');
        printf "%-30s %s\n" "$line_cropped" $( virt-addr "$line_cropped" );
    done;
    echo "----------------------------------------------";
}

virt-uuid() {
    VM="$1"
    uuid=$(echo $2 | grep "<uuid" | sed "s/.*<uuid>\(.*\)<\/uuid>.*/\1/g" );
    echo $uuid
}

virt-mem() {
    VM="$1"
    mem=$(echo $2 | grep "<memory" | sed "s/.*<memory unit='KiB'>\(.*\)<\/memory>.*/\1/g" );
    echo "$( expr $mem / 1024 )mb"
}

virt-currmem() {
    VM="$1"
    mem=$(echo $2 | grep "<currentMemory" | sed "s/.*<currentMemory unit='KiB'>\(.*\)<\/currentMemory>.*/\1/g" );
    echo "$( expr $mem / 1024 )mb"
}

virt-vcpu() {
    VM="$1"
    vcpu=$(echo $2 | grep "<vcpu" | sed "s/.*<vcpu[^>]*>\(.*\)<\/vcpu>.*/\1/g" );
    echo $vcpu
}

virt-store() {
    VM="$1"

}

virt-info() {
    echo "------------------------------------------------------------------------------------------------------------------------";
    printf "%-30s%-17s%-12s%-12s%-8s%-40s\n" "VM Name" "IP Address" "Memory" "Current" "VCPUs" "UUID";
    virsh -c qemu:///system list --all | grep -o -E '[-]?[0-9]* [-._0-9a-zA-Z]+.*(running|shut off)' | while read -r line;
    do
        line_cropped=$(echo "$line" | sed -r 's/([-]|[0-9]+)[ ]+([-._0-9a-zA-Z]*)[ ]+(running|shut off)/\2/' );
        vmsource=$(virsh dumpxml $line_cropped)
        printf "%-30s%-17s%-12s%-12s%-8s%-40s\n" "$line_cropped" $( virt-addr "$line_cropped" "$vmsource" ) $( virt-mem "$line_cropped" "$vmsource" ) $( virt-currmem "$line_cropped" "$vmsource" ) $( virt-vcpu "$line_cropped" "$vmsource" ) $( virt-uuid "$line_cropped" "$vmsource" );
    done;
    echo "------------------------------------------------------------------------------------------------------------------------";
}
virt-info
