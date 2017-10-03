#!/bin/sh

echo "READING VARIABLES......"
echo "."

PRTCONF=/tmp/PRTCONF
/usr/sbin/dmidecode > $PRTCONF
SERIALNO=` egrep "Serial Number" $PRTCONF | head -1 | awk '{print $3}'`
HSTNM=`egrep $SERIALNO /tmp/details.txt |grep -i 'SRV-DATA-MGMT-' |awk '{print $3}' |sed -e 's/\(.*\)/\L\1/'`
MGMTIP=`egrep $SERIALNO /tmp/details.txt |grep -i 'SRV-DATA-MGMT-' |awk '{print $7}'`
MGMTMSK=`egrep $SERIALNO /tmp/details.txt |grep -i 'SRV-DATA-MGMT-' |awk '{print $8}'`
MGMTGW=`egrep $SERIALNO /tmp/details.txt |grep -i 'SRV-DATA-MGMT-' |awk '{print $9}'`

echo "Starting Adapter Sorting ......."
echo "."

cp /etc/udev/rules.d/70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules.original
mkdir -p /lib/udev/bkp
mv -f /lib/udev/write_net_rules /lib/udev/bkp
lspci |grep Ethernet |sort -k 7,1 > /tmp/sorted
a=1
num=`cat /tmp/sorted |wc -l`
n=$((num+1))
ETHID=0
service network stop
> /etc/udev/rules.d/70-persistent-net.rules
while [ $a -lt $n ]
do
   if [ $a -eq $n ]
   then
      break
   else
   slot=`sed -n "$a"p /tmp/sorted |awk '{print $1}'`
#   echo $slot
   mac=`cat /sys/bus/pci/devices/0000:$slot/net/*/address`
   dev=`cat /sys/bus/pci/devices/0000:$slot/device`
   vend=`cat /sys/bus/pci/devices/0000:$slot/vendor`
   drv=`readlink /sys/bus/pci/devices/0000:$slot/driver |awk 'NF>1{print $NF}'`
#   echo $mac
#   echo eth${ETHID}
   cat >> /etc/udev/rules.d/70-persistent-net.rules << EOF

# PCI device $dev:$vend ($drv)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="$mac", ATTR{type}=="1", KERNEL=="eth*", NAME="eth${ETHID}"
EOF
   fi
   a=`expr $a + 1`
   let ETHID++
done

echo "STARTING HOSTNAME CONFIGURATION ... "

cat > /etc/sysconfig/network << EOF
NETWORKING=yes
HOSTNAME=$HSTNM
EOF

echo "COMPLETED HOSTNAME CONFIGURATION ... "

echo "STARTING NETWORK CONFIGURATION ... "

mkdir -p /network-backup

cp /etc/sysconfig/network-scripts/ifcfg-eth0 /network-backup/ifcfg-eth0
cp /etc/sysconfig/network-scripts/ifcfg-eth1 /network-backup/ifcfg-eth1
cp /etc/sysconfig/network-scripts/ifcfg-eth2 /network-backup/ifcfg-eth2
cp /etc/sysconfig/network-scripts/ifcfg-eth3 /network-backup/ifcfg-eth3
cp /etc/sysconfig/network-scripts/ifcfg-eth4 /network-backup/ifcfg-eth4
cp /etc/sysconfig/network-scripts/ifcfg-eth5 /network-backup/ifcfg-eth5
cp /etc/sysconfig/network-scripts/ifcfg-eth6 /network-backup/ifcfg-eth6
cp /etc/sysconfig/network-scripts/ifcfg-eth7 /network-backup/ifcfg-eth7
> /etc/sysconfig/network-scripts/ifcfg-eth1
> /etc/sysconfig/network-scripts/ifcfg-eth2
> /etc/sysconfig/network-scripts/ifcfg-eth3
> /etc/sysconfig/network-scripts/ifcfg-eth4
> /etc/sysconfig/network-scripts/ifcfg-eth5
> /etc/sysconfig/network-scripts/ifcfg-eth6
> /etc/sysconfig/network-scripts/ifcfg-eth7

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="static"
NM_CONTROLLED="no"
ONBOOT="yes"
TYPE="Ethernet"
NETMASK=$MGMTMSK
IPADDR=$MGMTIP
GATEWAY=$MGMTGW
EOF

rm /tmp/details.txt
rm /tmp/postdeploy.sh

echo "COMPLETED NETWORK CONFIGURATION ... "
echo "CONFIGURING CRON JOB FOR SPACEWALK ... "
cat > /var/spool/cron/root << EOF
00 1 * * * /tmp/spacewalk-client.sh
45 6 * * * /usr/sbin/rhn_check
EOF
reboot
