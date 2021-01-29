#!/bin/bash

PORT=${PORT:-3333}
LIVECD=${LIVECD:-"arch.iso"}
IMAGE=${IMAGE:-"img.raw"}
QEMU_ARCH=${QEMU_ARCH:-"x86_64"}
MEM="${MEM:-4G}"
CPU="${CPU:-4}"

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

usage() {
    echo "Usage: vm (start|livecd|ssh|kill)"
}

main "$@"
