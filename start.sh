qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 4G \
    -smp 4 \
    -drive \
    file=base.img,format=qcow2 \
    -nic user,hostfwd=tcp::3000-:22 \
    -nographic
