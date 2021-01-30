#!/bin/bash
# SPDX-License-Identifier: MIT
#
# Bootstrap a minimal archlinux virtual machine with qemu.
# Copyright (c) 2021  William Findlay
#
# January 29, 2021  William Findlay  Created this.

PORT=${PORT:=3333}
LIVECD=${LIVECD:="arch.iso"}
IMAGE=${IMAGE:="img.raw"}
QEMU_ARCH=${QEMU_ARCH:="x86_64"}
MEM="${MEM:=4G}"
CPU="${CPU:=4}"
DISK_SIZE="${DISK_SIZE:=20G}"

main() {
    case "$1" in
        start)
            start_vm
            ;;
        livecd)
            livecd_vm
            ;;
        ssh)
            ssh_vm
            ;;
        kill)
            kill_vm
            ;;
        bootstrap)
            bootstrap_vm
            ;;
        *)
            usage
    esac

    exit 0
}

start_vm() {
    qemu-system-$QEMU_ARCH \
        -net user,hostfwd=tcp::$PORT-:22 \
        -net nic \
        -m 256 \
        -drive file="$IMAGE",format=raw \
        -nographic
}

livecd_vm() {
    qemu-system-$QEMU_ARCH \
        -cdrom "$LIVECD" \
        -boot d \
        -net user,hostfwd=tcp::$PORT-:22 \
        -net nic \
        -m 256 \
        -drive file="$IMAGE",format=raw \
        -nographic
}

ssh_vm() {
    ssh -p $PORT root@localhost
}

kill_vm() {
    kill `ps ax | grep "qemu-system-$QEMU_ARCH" | awk 'NR==1{print $1}'`
}

bootstrap_vm() {
    prompt_user "This command will overwrite $IMAGE with a new qemu-img of size $DISK_SIZE. Continue?" || exit 127

    export IMAGE
    export LIVECD

    rm -f "$IMAGE"
    qemu-img create -f raw "$IMAGE" "$DISK_SIZE"

    expect -f ./scripts/bootstrap.exp
}

prompt_user() {
    read -p "$* [y/N]: " yn
    case $yn in
        [Yy]*) return 0  ;;
            *) echo "Aborted" ; return  1 ;;
    esac
}

usage() {
    echo "Usage: vm (start|livecd|ssh|kill|bootstrap)"
}

main "$@"
