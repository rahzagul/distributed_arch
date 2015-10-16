#!/bin/bash

USER_DATA=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-hostname`
HOSTNAME=`echo $USER_DATA`
IPV4=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`

sudo -s <<EOF
rm /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "$IPV4 $HOSTNAME" >> /etc/hosts
EOF

sudo -s <<EOF
rm /etc/sysconfig/network
echo "NETWORKING=yes" >> /etc/sysconfig/network
echo "NETWORKING_IPV6=no" >> /etc/sysconfig/network
echo "HOSTNAME=$USER_DATA" >> /etc/sysconfig/network
EOF

sudo -s <<EOF
rm /etc/selinux/config
echo "# This file controls the state of SELinux on the system." >> /etc/selinux/config
echo "# SELINUX= can take one of these three values:" >> /etc/selinux/config
echo "#     enforcing - SELinux security policy is enforced." >> /etc/selinux/config
echo "#     permissive - SELinux prints warnings instead of enforcing." >> /etc/selinux/config
echo "#     disabled - No SELinux policy is loaded." >> /etc/selinux/config
echo "SELINUX=disabled" >> /etc/selinux/config
echo "# SELINUXTYPE= can take one of these two values:" >> /etc/selinux/config
echo "#     targeted - Targeted processes are protected," >> /etc/selinux/config
echo "#     mls - Multi Level Security protection." >> /etc/selinux/config
echo "SELINUXTYPE=targeted" >> /etc/selinux/config
EOF
