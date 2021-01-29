#!/bin/bash

export IMG=img.raw
export ISO=arch.iso

rm -f "$IMG"
qemu-img create -f raw "$IMG" 20G

expect -f ./scripts/bootstrap.exp
