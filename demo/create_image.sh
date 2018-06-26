#!/bin/bash
## the size create image disk
exit 0
size_disk=3G;
image="swop_disk.img";

fallocate -l $size_disk $image ;
echo ok...
exit 0
