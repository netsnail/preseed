#!/bin/bash

DIST=utopic

mkdir /tmp/iso

echo "copy isolinux files..."
cp /usr/lib/syslinux/isolinux.bin /tmp/iso/
cp /usr/lib/syslinux/vesamenu.c32 /tmp/iso/
cp /usr/lib/syslinux/hdt.c32 /tmp/iso/
wget -q http://pciids.sourceforge.net/v2.2/pci.ids -O /tmp/iso/pci.ids

echo "download 32bit non-pae kernel and initrd..."
mkdir /tmp/iso/nonpae
wget -q http://www.archive.ubuntu.com/ubuntu/dists/precise/main/installer-i386/current/images/netboot/non-pae/ubuntu-installer/i386/linux -O /tmp/iso/nonpae/linux32
wget -q http://www.archive.ubuntu.com/ubuntu/dists/precise/main/installer-i386/current/images/netboot/non-pae/ubuntu-installer/i386/initrd.gz -O /tmp/iso/nonpae/initrd32.gz

echo "download 32bit ${DIST} kernel and initrd..."
wget -q http://archive.ubuntu.com/ubuntu/dists/${DIST}/main/installer-i386/current/images/netboot/ubuntu-installer/i386/linux -O /tmp/iso/linux32
wget -q http://archive.ubuntu.com/ubuntu/dists/${DIST}/main/installer-i386/current/images/netboot/ubuntu-installer/i386/initrd.gz -O /tmp/iso/initrd32.gz

echo "download 64bit ${DIST} kernel and initrd..."
wget -q http://archive.ubuntu.com/ubuntu/dists/${DIST}/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux -O /tmp/iso/linux64
wget -q http://archive.ubuntu.com/ubuntu/dists/${DIST}/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz -O /tmp/iso/initrd64.gz

echo "download www.panticz.de iPXE boot image..."
wget http://dl.panticz.de/ipxe/ipxe.iso -P /tmp/
mount /tmp/ipxe.iso /mnt/ -o loop
cp /mnt/ipxe.krn /tmp/iso/
umount /mnt

echo "download isolinux configuration..."
wget -q --no-check-certificate https://raw.githubusercontent.com/panticz/preseed/master/pxe/isolinux.cfg -O /tmp/iso/isolinux.cfg

# TODO: download background
# wget http://www.heise.de/ct/motive/image/1485/p800.jpg -O /tmp/iso/background.jpg
# convert -resize 480x640 /tmp/iso/background.jpg /tmp/isobackground.jpg
 
# TODO: add Ubuntu Live CD to image (DVD only?)
# wget http://releases.ubuntu.com/14.10/ubuntu-14.10-desktop-amd64.iso -P /tmp/
# mount /tmp/ubuntu-14.10-desktop-amd64.iso /mnt/ -o loop
# cp -a /mnt/.disk/ /tmp/iso/
# cp -a /mnt/casper/ /tmp/iso/
# umount /mnt

echo "create iso image..."
mkisofs -q -V "UbuntuNetInstall" -o /tmp/UbuntuNetInstall.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -r -J /tmp/iso

echo "clean up..."
rm -r /tmp/iso

# check if brasero installed
if [ -f /usr/bin/brasero ]; then
   echo "burn cd..."
   brasero /tmp/UbuntuNetInstall.iso &
fi
