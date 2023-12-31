# Network booting Raspberry Pi

This converts a Raspberry Pi container to a network booting
image. That allows you to run a Raspberry Pi without an SD card.

The goal is to allow radio tower installation of with no wearing parts
like an SD card. All files are safu because the system and disk
server can be separated by a fiber connection or other means of
physical isolation.

## Requirements

Raspberry Pi 3 or newer is required.

First, install
[raspberrypi-podman](https://github.com/zouppen/raspberrypi-podman)
and run `convert_rpi_to_podman` with a image of your choice.

Additional Debian/Ubuntu requirements:

```sh
sudo apt install qemu-user-static podman btrfs-progs
```

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

## Preparing Raspi for network booting

See [How to PXE boot a Raspberry](https://www.howtoraspberry.com/2022/03/how-to-pxe-boot-a-raspberry/) for instructions how to set boot order and boot settings on your Raspi.

## Preparing server

TODO container which runs all the necessary tools. Meanwhile, you need
to set up your dnsmasq with DHCP and TFTP and also NFSv4 server
somewhere.

## Author

Written by Joel Lehtonen / Zouppen. Licenced under the terms of MIT license.
