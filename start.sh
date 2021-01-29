qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 4G \
    -smp 4 \
    -drive \
    file=img.raw,format=raw \
    -nic user,hostfwd=tcp::3333-:22 \
    -nographic
