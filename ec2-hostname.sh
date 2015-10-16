#!/bin/bash

echo $USER
sudo -s <<EOF1
echo Now I am root
echo $USER

USER_DATA=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-hostname`
HOSTNAME=`echo $USER_DATA`
IPV4=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
# IPV4=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-ipv4`

  # Set the host name
  hostname $HOSTNAME
  echo $HOSTNAME > /etc/hostname

  # Add fqdn to hosts file
  sudo cat<<EOF2 > /etc/hosts
  # This file is automatically genreated by ec2-hostname script
  127.0.0.1 localhost
  $IPV4 $HOSTNAME
  EOF2

  # Add fqdn to network file
  sudo cat<<EOF3 > /etc/sysconfig/network
  NETWORKING=yes
  NETWORKING_IPV6=no
  HOSTNAME=$USER_DATA
  EOF3

  # Disable SELinux
  sudo cat<<EOF4 > /etc/selinux/config
  # This file controls the state of SELinux on the system.
  # SELINUX= can take one of these three values:
  #     enforcing - SELinux security policy is enforced.
  #     permissive - SELinux prints warnings instead of enforcing.
  #     disabled - No SELinux policy is loaded.
  SELINUX=disabled
  # SELINUXTYPE= can take one of these two values:
  #     targeted - Targeted processes are protected,
  #     mls - Multi Level Security protection.
  SELINUXTYPE=targeted
  EOF4
EOF1
