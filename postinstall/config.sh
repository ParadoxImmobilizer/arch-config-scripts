set -x
set -e
user=main
user_password=1234
admin_password=1234
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
cat /etc/default/grub | sed "s/loglevel=3 quiet/loglevel=3/" > /tmp/sed-temp
cat /tmp/sed-temp > /etc/default/grub
rm /tmp/sed-temp
useradd -m $user
(
echo $user_password
echo $user_password
) | passwd $user
usermod -aG wheel $user
usermod -aG vboxsf $user
cp .bashrc .alias .x410.sh /home/$user
mkdir -p /home/$user/.config/gtk-3.0
cp settings.ini /home/$user/.config/gtk-3.0
grub-install --efi-directory=/mnt/boot/efi /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg