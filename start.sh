PORT=3333
LIVECD="arch.iso"
IMAGE="img.raw"
QEMU_ARCH="x86_64"

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

start_vm() {
    qemu-system-$QEMU_ARCH \
        -net user,hostfwd=tcp::$PORT-:22 \
        -net nic \
        -m 256 \
        -hda "$IMAGE" \
        -display curses
}

livecd_vm() {
    qemu-system-$QEMU_ARCH \
        -cdrom "$LIVECD" \
        -boot d \
        -net user,hostfwd=tcp::$PORT-:22 \
        -net nic \
        -m 256 \
        -hda "$IMAGE" \
        -display curses
}

ssh_vm() {
    ssh -o $PORT root@localhost
}

kill_vm() {
    kill `ps ax | grep "qemu-system-$QEMU_ARCH" | awk 'NR==1{print $1}'`
}

usage() {
    echo "Usage: vm (start|livecd|ssh|kill)"
}
