# The Minimal image for Pignus
# Build with: appliance-creator -c pignus-minimal.ks

lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --passalgo sha256
firewall --enabled --service=mdns
xconfig --startxonboot
selinux --enforcing
bootloader --append="console=ttyAMA0 console=tty0 rhgb"

part /boot --size=256 --fstype vfat --label boot
part / --size=2048 --grow --fstype ext4

services --enabled=NetworkManager --disabled=network,firewalld

repo --name=koji --baseurl=https://pignus.computer/pub/linux/pignus/releases/$releasever/Everything/$basearch/os/

%packages
@core
pignus-release
kernel
uboot-tools
uboot-images-armv7
bcm283x-firmware
extlinux-bootloader
plymouth-theme-spinner
NetworkManager-wifi
# Not strictly needed, but useful: Out boot is a msdos filesystem and this
# is useful for automated systemd-triggered check
dosfstools
# The device has no RTC
chrony
# Include the MMC controller
dracut-config-generic
%end

%post --erroronfail
# Install VideoCore firmware
cp -a /usr/share/bcm283x-firmware/* /boot

# Install bootloader
cp /usr/share/uboot/rpi/u-boot.bin /boot/

# Remove root password
passwd -d root
%end
