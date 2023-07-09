# Netbooting raspi

Based on https://github.com/zouppen/raspberrypi-podman so first install that container.

## Dumping the image for NFS and TFTP

The following script builds this container and creates a btrfs image
`image.img` ready for deployment. It requires no root privileges,
everything is done in a modified user namespace.

```
./generate_image image.img
```

The resulting file system is not compressed and has no btrfs
submodules. Those are not mandatory. But if you want, there is a
script which creates subvolume `root`, sets it as default and
compresses all files in there with zstd:

```
sudo ./compact_image image.img
```

Mount the image and read `/boot` directory from there to your TFTP root.

### Boot directory preparation

If PXE booting or with boot only SD card, you need to adjust
`cmdline.txt` and add the following items to the kernel command line
and removing existing root item:

```
rw root=/dev/nfs nfsroot=/srv/nfs/info,nfsvers=4.2 nfsfile=btrfs.img apparmor=0 net.ifnames=0
```

Adding `net.ifnames=0` and `apparmor=0` is optional but helps to solve issues with NFS booting.

## Author

Written by Joel Lehtonen / Zouppen. Licenced under the terms of MIT license.
