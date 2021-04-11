user=main
user_password=1234
admin_password=1234
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
echo $admin_password
echo $admin_password
) | passwd
cat /etc/default/grub | sed "s/loglevel=3 quiet/loglevel=3/" | /etc/default/grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m $user
(
echo $user_password
echo $user_password
) | passwd $user
usermod -aG wheel $user
usermod -aG vboxsf $user
cp .bashrc /home/$user
systemctl enable dhcpcd.service
systemctl enable vboxservice.service
systemctl enable docker
visudo