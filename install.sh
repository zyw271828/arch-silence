rm -rf /boot/grub/themes/debian-silence
cp -TR ./theme /boot/grub/themes/debian-silence
grub-mkconfig -o /boot/grub/grub.cfg
