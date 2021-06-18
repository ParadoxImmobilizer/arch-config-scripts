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
pacstrap /mnt base linux linux-firmware mousepad ristretto thunar-archive-plugin thunar-media-tags-plugin xfce4-clipman-plugin xfce4-fsguard-plugin xfce4-notifyd \
xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin vim mc htop grub sudo dhcpcd xfce4 xorg-server firefox noto-fonts ntfs-3g gvfs virtualbox-guest-utils arc-gtk-theme \
papirus-icon-theme vlc unzip git docker-compose vlc wireguard-tools openresolv pavucontrol pulseaudio neofetch
genfstab -U /mnt >> /mnt/etc/fstab
[ $dbm == True ] && read -p "Writing second part of script to disk..."
cp config.sh /mnt/
cp .bashrc /mnt/
[ $dbm == True ] && read -p "starting part 2..."
chmod +x /mnt/config.sh
arch-chroot /mnt ./config.sh
# 3, 4, 5, 6, 9, 10, 11, 12, 14, 16, 17, 19, 21, 23, 24, 26, 27, 29, 38
# 1, 3, 4, 5, 6, 11, 22, 23, 28