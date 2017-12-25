# Install Arch Linux

## Preparation

1. [Download](https://archlinux.org/download/) ISO and GPG files
2. Verify the ISO file: `$ pacman-key -v archlinux-<version>-dual.iso.sig`
3. Create a bootable usb with: `# dd if=archlinux*.iso of=/dev/sdX && sync`

## UEFI

1. Disable SecureBoot.
2. Set SATA operation to AHCI mode.

## Boot from USB drive

1. Plug in network cable or connect to wifi with `# wifi-menu`, ensure you have internet access.
2. Enable NTP: `# timedatectl set-ntp true`

## Partition the disk

1. Note the disk name with `# fdisk -l`
2. Run `# cfdisk` for that disk and select label type `gpt`.
3. Create partitions:
    - 100M - EFI system
    - 100% - Linux filesystem
4. Reboot if necessary.
5. Create file systems on EFI and boot partitions:
    - `# mkfs.vfat -n EFI -F32 /dev/sdX1`
6. Encrypt the Linux partition:
    - `# cryptsetup -v luksFormat /dev/sdX2`
    - `# cryptsetup luksOpen /dev/sdX2 luks`
7. Create file system:
    - `# mkfs.btrfs -L btrfs /dev/mapper/luks`
8. Mount volumes:
    - `# mount /dev/mapper/luks /mnt`
    - `# btrfs subvolume create /mnt/root`
    - `# btrfs subvolume create /mnt/home`
    - `# btrfs subvolume create /mnt/pkgs`
    - `# btrfs subvolume create /mnt/logs`
    - `# btrfs subvolume create /mnt/tmp`
    - `# btrfs subvolume create /mnt/snapshots`
    - `# umount /mnt`
    - `# mount -o subvol=root,noatime,nodiratime,discard,compress=lzo /dev/mapper/luks /mnt`
    - `# mkdir -p /mnt/mnt/btrfs-root`
    - `# mkdir -p /mnt/boot/EFI`
    - `# mkdir -p /mnt/home`
    - `# mkdir -p /mnt/var/cache/pacman/pkg`
    - `# mkdir -p /mnt/var/log`
    - `# mkdir -p /mnt/var/tmp`
    - `# mkdir -p /mnt/.snapshots`
    - `# mount /dev/sdX1 /mnt/boot/EFI`
    - `# mount -o noatime,nodiratime,discard,compress=lzo,subvol=/ /dev/mapper/luks /mnt/mnt/btrfs-root`
    - `# mount -o noatime,nodiratime,discard,compress=lzo,subvol=home /dev/mapper/luks /mnt/home`
    - `# mount -o noatime,nodiratime,discard,compress=lzo,subvol=pkgs /dev/mapper/luks /mnt/var/cache/pacman/pkg`
    - `# mount -o noatime,nodiratime,discard,compress=lzo,subvol=logs /dev/mapper/luks /mnt/var/log`
    - `# mount -o noatime,nodiratime,discard,compress=lzo,subvol=tmp /dev/mapper/luks /mnt/var/tmp`
    - `# mount -o noatime,nodiratime,discard,compress=lzo,subvol=snapshots /dev/mapper/luks /mnt/.snapshots`

## Install Arch Linux

1. Install packages:
```
# pacstrap /mnt base base-devel
                btrfs-progs               # btrfs filesystem utilities
                grub efibootmgr           # boot manager
                intel-ucode               # Include Intel microcode patches during boot
                zsh git openssh           # Just enough to create a user and clone dotfiles
                terminus-font             # To make console font readable on HiDPI screens
                networkmanager            # Because wired connection may not work after installation
```
2. Generate fstab entries: `# genfstab -U /mnt >> /mnt/etc/fstab`
4. Enter the new system: `# arch-chroot /mnt`
5. Make console font readable on HiDPI screens:
    - `# setfont ter-132n`
    - `# echo "FONT=ter-132n" > /etc/vconsole.conf`
7. Setup time zone: `# ln -sf /usr/share/zoneinfo/Region/City /etc/localtime`
8. Configure hardware clock `# hwclock --systohc --utc`
9. Configure system locate:
    - `# echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen`
    - `# locale-gen`
    - `# echo LANG=en_US.UTF-8 >> /etc/locale.conf`
    - `# echo LANGUAGE=en_US >> /etc/locale.conf`
    - `# echo LC_ALL=en_US.UTF-8 >> /etc/locale.conf`
10. Configure hostname:
    - `# echo HOSTNAME > /etc/hostname`
    - `# echo "127.0.0.1 HOSTNAME.localdomain HOSTNAME" >> /etc/hosts`
    - TODO:
    ```
    127.0.0.1	localhost.localdomain	localhost
    ::1		localhost.localdomain	localhost
    ```
11. Configure password-less unlock of root partition;
    - `# dd bs=512 count=4 if=/dev/urandom of=/crypto_keyfile.bin`
    - `# chmod 000 /crypto_keyfile.bin`
    - `# chmod 600 /boot/initramfs-linux*`
    - `# cryptsetup luksAddKey /dev/sdX2 /crypto_keyfile.bin`
11. Generate initial ramdisk environment:
    - `# vi /etc/mkinitcpio.conf`
    - Add `consolefont` to HOOKS after `base`
    - Add `encrypt` to HOOKS before `filesystems`
    - Remove `fsck` from HOOKS
    - TODO maybe: add `crc32c-intel` to modules, check with https://wiki.archlinux.org/index.php/Btrfs#Checksum_hardware_acceleration
    - `# mkinitcpio -p linux`
13. Configure bootloader:
    - `# vim /etc/default/grub`
    - Uncomment `GRUB_ENABLE_CRYPTODISK=y`
    - Set `GRUB_CMDLINE_LINUX="cryptdevice=/dev/sdX2:luks:allow-discards"`
    - Set `GRUB_GFXMODE=1280x1024x32,1024x768x32,auto`
    - Comment out `#GRUB_GFXPAYLOAD_LINUX` (terminus font is great at native resolution)
    - `# grub-mkconfig -o /boot/grub/grub.cfg`
    - `# grub-install`
13. Generate machine id: `# dbus-uuidgen --ensure`
14. Set `zsh` as default shell for root: `chsh -s /bin/zsh`
15. Create a user:
    - `# useradd -m -g users -G wheel -s /bin/zsh USERNAME`
    - `# passwd USERNAME`
    - `# EDITOR=vi visudo` and uncomment sudo access for `wheel` group
3. Exit new system and reboot:
    - `# exit`
    - `# umount -R /mnt`
    - `# reboot`

## Final system configuration

1. Login as the new user
2. Start NetworkManager service: `$ sudo systemctl start NetworkManager`
2. Finish system setup:
    - Clone dotfiles: `$ git clone https://github.com/maximbaz/dotfiles.git ~/.dotfiles`
    - Bootstrap pacman packages: `$ ~/.dotfiles/bin/bootstrap.sh pacman`
    - Install AUR package manager: 
        - `$ git clone https://aur.archlinux.org/yay.git /tmp/yay`
        - `$ cd /tmp/yay`
        - `$ makepkg -i`
    - Bootstrap AUR packages: `$ ~/.dotfies/bin/bootstrap.sh aur`
    - Install configuration: `$ ~/.dotfiles/setup.sh`
    - Reinitialize shell: `$ exec zsh -l`
3. Exit new system and reboot:
    - `$ exit`
    - `# exit`
    - `# umount -R /mnt`
    - `# reboot`
15. Disable root password: `# passwd -dl root`
