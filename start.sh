#!/bin/bash

IMG="${IMG:-img.raw}"
FMT="${FMT:-raw}"
MEM="${MEM:-4G}"
CPU="${CPU:-4}"

qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m "$MEM" \
    -smp "$CPU" \
    -drive \
    file="$IMG",format=raw \
    -nic user,hostfwd=tcp::3333-:22 \
    -nographic
