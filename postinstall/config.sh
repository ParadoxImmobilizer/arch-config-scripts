set -x
set -e
user=main
user_password=1234
admin_password=1234
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "arch" > /etc/hostname
cat > /etc/hosts << EOF
echo 127.0.0.1    localhost
echo ::1          localhost
echo 127.0.1.1    arch.localdomain    arch
EOF
(
echo $admin_password
echo $admin_password
) | passwd
sed -i "s/loglevel=3 quiet/loglevel=3/" /etc/default/grub
rm /tmp/sed-temp
useradd -m $user
(
echo $user_password
echo $user_password
) | passwd $user
usermod -aG wheel $user
systemctl enable sshd
systemctl enable dhcpcd
grub-install --efi-directory=/boot/efi /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
