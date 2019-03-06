#!/bin/bash

if [ -z "$1" ]
then
    echo "Enter your username: "
    read user
else
    user=$1
fi

if [ -z "$2" ]
then
    echo "Enter your master password: "
    read -s password
else
    password=$2
fi

if [ -z "$3" ]
then
    echo "Do you want to skip rankmirrors (faster upfront)? [y/N] "
    read response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
    then
        fast=1
    else
        fast=0
    fi
else
    fast=$3
fi

# set time
timedatectl set-ntp true

#partiton disk
parted --script /dev/sda mklabel msdos mkpart primary ext4 0% 87% mkpart primary linux-swap 87% 100%
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt
mkdir /mnt/home

parted --script /dev/sdb mklabel msdos mkpart primary ext4 0% 100%
mkfs.ext4 /dev/sdb1
mount /dev/sdb1 /mnt/home

# pacstrap
pacstrap /mnt base

# fstab
genfstab -U /mnt >> /mnt/etc/fstab
genfstab -U /mnt/home >> /mnt/etc/fstab

# chroot
wget https://raw.githubusercontent.com/gheber/spartan-arch/master/chroot-install.sh -O /mnt/chroot-install.sh
arch-chroot /mnt /bin/bash ./chroot-install.sh $user $password $fast

# reboot
umount /mnt/home
umount /mnt
reboot
