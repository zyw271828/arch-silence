#!/bin/bash

readonly ROOT_UID=0
THEME_DIR="/usr/share/grub/themes"
NAME="debian-silence"

if [ "$UID" -eq "$ROOT_UID" ]; then
    # Create themes directory if not exists
    [[ -d "${THEME_DIR}/${NAME}" ]] && rm -rf "${THEME_DIR}/${NAME}"
    mkdir -p "${THEME_DIR}/${NAME}"

    # Copy theme
    cp -r ./theme/* "${THEME_DIR}/${NAME}"

    # Backup grub config
    cp -an /etc/default/grub /etc/default/grub.bak

    grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub
    grep "GRUB_GFXMODE=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_GFXMODE=/d' /etc/default/grub

    # Edit grub config
    echo "GRUB_THEME=\"${THEME_DIR}/${NAME}/theme.txt\"" >>/etc/default/grub
    echo "GRUB_GFXMODE=auto" >>/etc/default/grub

    # Update grub config
    if has_command update-grub; then
        update-grub
    elif has_command grub-mkconfig; then
        grub-mkconfig -o /boot/grub/grub.cfg
    elif has_command zypper; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
    elif has_command dnf; then
        grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    fi
else
    # Error message
    prompt -e "Run as root."
fi
