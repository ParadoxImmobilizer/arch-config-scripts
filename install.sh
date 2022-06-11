set -x
set -e
timedatectl set-ntp true

# Configure disk
sfdisk /dev/sda < filesys
mkfs.ext4 -F /dev/
mkfs.fat -F 32 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda3 /mnt/boot/

# Configure pacman
cat /etc/pacman.conf | sed 's/#Color/Color/' > /tmp/pac_conf
cat /tmp/pac_conf | sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' > /etc/pacman.conf

sed -i -e 's/#Color/Color/' -e 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
cat /tmp/pac_conf | sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' > /etc/pacman.conf

# Generate mirrorlist
pacman -Sy
pacman -S --noconfirm pacman-contrib
curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4" | \
	sed -e 's/.Server/Server/' | \
	rankmirrors -n 10 - > /etc/pacman.d/mirrorlist

# Install OS
foo="base base-devel linux linux-firmware vim mc grub sudo dhcpcd unzip efibootmgr neofetch \
man-pages man-db xfce4 neofetch ristretto thunar-archive-plugin thunar-media-tags-plugin git \
xfce4-clipman-plugin xfce4-datetime-plugin xfce4-mount-plugin  pavucontrol pulseaudio htop \
xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin gvfs arc-gtk-theme vlc xorg-server noto-fonts \
papirus-icon-theme firefox wireguard-tools openresolv docker-compose zsh socat xfce4-notifyd"

# Copy installation files
pacstrap /mnt $foo
genfstab -U /mnt > /mnt/etc/fstab
cp postinstall/. /mnt/
chmod +x /mnt/config.sh

# Run config utility
arch-chroot /mnt ./config.sh