dbm=False
[ $1 == "-c" ] && dbm=True
[ $dbm == True ] && read -p "Setting up filesystem..."
sfdisk /dev/sda < filesys
timedatectl set-ntp true
mkfs.ext4 -F /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt
[ $dbm == True ] && read -p "Installing pacman-contrib..."
pacman -S --noconfirm pacman-contrib
[ $dbm == True ] && read -p "Configuring mirrorlist..."
curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4" | sed -e 's/.Server/Server/' | rankmirrors -n 10 - > /etc/pacman.d/mirrorlist
[ $dbm == True ] && read -p "Installing base system..."
pacstrap -i /mnt base linux base-devel linux-firmware vim grub sudo dhcpcd xfce4 xorg-server xfce4-goodies qbittorrent firefox noto-fonts ntfs-3g gvfs virtualbox-guest-utils arc-gtk-theme papirus-icon-theme vlc base-devel unzip
genfstab -U /mnt >> /mnt/etc/fstab
[ $dbm == True ] && read -p "Writing second part of script to disk..."
echo '
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "arch" > /etc/hostname
echo 127.0.0.1	localhost >> /etc/hosts
echo ::1		localhost >> /etc/hosts
echo 127.0.1.1	arch.localdomain	arch >> /etc/hosts
(
echo 1234
echo 1234
) | passwd
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m bold
(
echo 1234
echo 1234
) | passwd bold
usermod -aG wheel bold vboxsf
systemctl enable dhcpcd.service
systemctl enable vboxservice.service
visudo
' > /mnt/test.sh
[ $dbm == True ] && read -p "starting part 2..."
chmod +x /mnt/test.sh
arch-chroot /mnt ./test.sh
# shutdown now
# 3, 4, 5, 6, 9, 10, 11, 12, 14, 16, 17, 19, 21, 23, 24, 26, 27, 29, 38
# 1, 3, 4, 5, 6, 11, 22, 23, 28
