#!/bin/bash

export IMG="${IMG:-img.raw}"
export FMT="${FMT:-raw}"
export ISO="${ISO:-arch.iso}"
export SIZE="${SIZE:-20G}"

rm -f "$IMG"
qemu-img create -f raw "$IMG" 20G

expect -f ./scripts/bootstrap.exp
