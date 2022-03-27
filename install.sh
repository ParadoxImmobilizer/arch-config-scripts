set -x
set -e
sfdisk /dev/sda < filesys
timedatectl set-ntp true
mkfs.ext4 -F /dev/sda1
mkfs.mkfs.fat -F 32 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda3 /mnt/boot/efi
sed -i 's/#Color/Color/' > /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' > /etc/pacman.conf
pacman -Sy
pacman -S --noconfirm pacman-contrib
curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4" | \
	sed -e 's/.Server/Server/' | \
	rankmirrors -n 10 - > /etc/pacman.d/mirrorlist

# default="base base-devel linux linux-firmware vim mc htop grub sudo dhcpcd \
# unzip networkmanager efibootmgr neofetch ntfs-3g git"
# xfce="xfce4 neofetch ristretto thunar-archive-plugin thunar-media-tags-plugin \
# xfce4-clipman-plugin xfce4-datetime-plugin xfce4-fsguard-plugin \
# xfce4-genmon-plugin xfce4-mount-plugin xfce4-notifyd pavucontrol pulseaudio \
# xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin gvfs arc-gtk-theme"
# gui="vlc xorg-server noto-fonts papirus-icon-theme network-manager-applet \
# firefox"
# laptop="xfce4-battery-plugin"
# mullvad="wireguard-tools openresolv"
# vbox="virtualbox-guest-utils"
# docker="docker-compose"
# network="xfce4-netload-plugin"

foo="base base-devel linux linux-firmware vim mc  grub sudo dhcpcd unzip efibootmgr neofetch \
man-pages man-db xfce4 neofetch ristretto thunar-archive-plugin thunar-media-tags-plugin \
xfce4-clipman-plugin xfce4-datetime-plugin xfce4-mount-plugin  pavucontrol pulseaudio htop \
xfce4-pulseaudio-plugin xfce4-whiskermenu-plugin gvfs arc-gtk-theme vlc xorg-server noto-fonts \
papirus-icon-theme firefox wireguard-tools openresolv docker-compose zsh socat xfce4-notifyd"

pacstrap /mnt $foo
genfstab -U /mnt > /mnt/etc/fstab
cp postinstall/* /mnt/
chmod +x /mnt/config.sh
#arch-chroot /mnt ./config.sh