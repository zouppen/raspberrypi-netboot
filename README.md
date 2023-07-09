# Netbooting raspi

Based on https://github.com/zouppen/raspberrypi-podman so first install that container.

Then,

```sh
podman build -t raspi-netboot .
```

## Dumping the image for NFS and TFTP

Creating the container and dumping tar archive

```
podman create raspi-netboot
```


### Boot directory preparation

If PXE booting or with boot only SD card, you need to adjust
`cmdline.txt` and add the following items to the kernel command line
and removing existing root item:

```
rw root=/dev/nfs nfsroot=/srv/nfs/info,nfsvers=4.2 nfsfile=btrfs.img apparmor=0 net.ifnames=0
```

Adding `net.ifnames=0` and `apparmor=0` is optional but helps to solve issues with NFS booting.
