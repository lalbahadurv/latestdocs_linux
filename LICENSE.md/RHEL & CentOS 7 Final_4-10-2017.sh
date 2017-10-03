#!/bin/bash
#Created by Sharjeel Nabi (Consultant)
DIR="$(mkdir -p /etc/BackupSystemFiles.`date +%d%b%Y`.org)"
Desti="/etc/BackupSystemFiles.`date +%d%b%Y`.org"
backup_files="/etc/*"
# create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
HARD_LOG="/var/log/$(hostname)-CIS_hard_log"
archive_file="$hostname-$day.tar.gz"
NS1=10.66.15.201
NS2=10.66.9.204
NTP1="server     idc1ntp.idc.ril.com"	
NTP2="server     idc1ntp1.idc.ril.com"
function wait() {
local msg1=$1
local msg2=$2
local msg3=$3
        echo -e "\n\033[0m$1 $2 \t\t\t\t\t""\e[00;32m$3\e[00m\v"
sleep 1
}
echo -en  " $(date +%d%b%Y" "%r) :\tPlease wait........ backing up $backup_files to $Desti is in progess\n"  >> $HARD_LOG
echo
#backup  the file using TAR
tar -cvzf $Desti/$archive_file $backup_files | while read line ; do echo "$(date +%d%b%Y" "%r ) : ${line}" ; done >> $HARD_LOG
sleep 10
echo -en "backup finished" date >> $HARD_LOG
echo -en  "Files have been copied $Desti\n" | while read line ; do echo "$(date +%d%b%Y" "%r ) : ${line}" ; done >> $HARD_LOG

echo -en  "##################################ETC BACKUP DONE##################################################\n" >> $HARD_LOG


#######################Lock the Unneccessary Accounts###################################################
echo -e "#CIS  5.4.2 Lock the Unneccessary Accounts"
echo -e "#CIS  5.4.2 Lock the Unneccessary Accounts" >> $HARD_LOG

echo "Locking the Uneccessary Accounts">>$HARD_LOG
for USERID in rpc rpcuser lp named dns mysql postgres squid news netdump shutdown halt uucp games gopher ftp
do
usermod -L -s /sbin/nologin $USERID &>/dev/null
done

lgroupmod -L dip
lgroupdel dip

echo -en "###################Unneccessary Accounts Locked ##############################################\n ">> $HARD_LOG

echo -e "#CIS  5.4.2 Block System Accounts"
echo -e "#CIS  5.4.2 Block System Accounts" >> $HARD_LOG

############################Block System Accounts#####################################
#cp -p /etc/passwd /etc/BackupSystemFiles/passwd.prehard
for NAME in `cut -d: -f1 /etc/passwd`;
do
MyUID=`id -u $NAME`
if [ $MyUID -lt 1000 -a $NAME != 'root' ]; then
usermod -L -s /sbin/nologin $NAME
fi
done
######Verify passwd, shadow and group file permissions#######
cd /etc
ls -l > /etc/etc.files

echo -e "#CIS  6.2.5 Verifying That No Non-Root Account have UID 0"
echo -e "#CIS  6.2.5 Verifying That No Non-Root Account have UID 0" >> $HARD_LOG

#--------------------------------------------------
### Verifying That No Non-Root Account have UID 0
#--------------------------------------------------
NON=`awk -F: '($3 == "0") {print}' /etc/passwd |cut -d ":" -f1`
	if [ "$NON" == 'root' ];then
wait "Verifying" "NON-ROOT" "DONE"
	else
wait "Verifying" "NON-ROOT" "\e[00;31mFAIL\e[00m"
echo -e "\e[00;31m\e[5mHaving Multiple NON-ROOT Account\e[00m"
	fi

awk -F: '($3 == 0) { print "UID 0 Accounts are Below. Please do block if its not neccessary\n" $1 }' /etc/passwd>> $HARD_LOG


echo -en "## SSH Login Banner############################################################################\n" >> $HARD_LOG

echo "Updating the banner in /etc/issue  file" >> ${HARD_LOG}
cat > /etc/issue <<EOF
*******************************************************************************
+                           =====================                             +
+                           !!! C A U T I O N !!!                             +
+                           =====================                             +
+                                                                             +
+               This system is for the use of authorized users only.          +
+       Individuals using this computer system without authority, or in       +
+       excess of their authority, are subject to having all of their         +
+       activities on this system monitored and recorded by system            +
+       personnel.                                                            +
+       In the course of monitoring individuals improperly using this         +
+       system, or in the course of system maintenance, the activitie         +
+       of authorized users may also be monitored.                            +
+       Anyone using this system expressly consents to such monitoring        +
+       and is advised that if such monitoring reveals possible               +
+       evidence of criminal activity, system personnel may provide the       +
+       evidence of such monitoring to law enforcement officials.             +
+                                                                             +
*******************************************************************************
EOF
echo Banner /etc/issue >> /etc/ssh/sshd_config
wait "Created" "Login BANNER" "DONE"

echo Banner /etc/issue >> /etc/ssh/sshd_config
wait "Created" "Login BANNER" "DONE"
echo -e "#CIS 1.7.1.1 -------------------------------------------------------"
echo -en "#CIS 1.7.1.1 -------------------------------------------------------\n">> $HARD_LOG

cat > /etc/motd <<EOF
********************************************************************************
+                           =====================                              +
+                           !!! W A R N I N G !!!                              +
+                           =====================                              +
+                                                                              +
+  ALERT! You are entering into a secured area! Your IP, Login Time, Username  +
+  has been noted and has been sent to the server administrator!               +
+  This service is restricted to authorized users only. All activities on this +
+  system are logged.                                                          +
+  Unauthorized access will be fully investigated and reported to the          +
+  appropriate law enforcement agencies.                                       +  
+  This system is for the use of authorized users only.                        +
+                                                                              +
********************************************************************************
Welcome to RIL Secure Zone !
EOF

wait "Created" "Login MOTD" "DONE"

echo -en "##################################################################################\n" >> $HARD_LOG

echo "##########################ADDITIONAL LINES###################" >>/etc/sysctl.conf



echo -e "#CIS 3.2.7 3.2.1 3.2.2 3.2.3 3.1.1 3.1.2 3.2.4 3.2.5 3.2.6 3.2.8 3.3.1 3.3.2 1.5.3 Set essential kernel parameters"
echo -e "#CIS 3.2.7 3.2.1 3.2.2 3.2.3 3.1.1 3.1.2 3.2.4 3.2.5 3.2.6 3.2.8 3.3.1 3.3.2 1.5.3 Set essential kernel parameters"
 >> $HARD_LOG

function10 () {
cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.rp_filter"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.default.rp_filter" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.default.rp_filter = 1 " >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.accept_source_route"   #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.accept_redirects"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.default.secure_redirects" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.secure_redirects" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.default.accept_redirects" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.ip_forward" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.send_redirects" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.default.send_redirects" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.default.accept_source_route" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.default.accept_source_route = 0 "  >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.tcp_max_syn_backlog" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.tcp_max_syn_backlog = 4096" >>  /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.icmp_echo_ignore_broadcasts" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1"  >>  /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.icmp_ignore_bogus_error_responses" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.icmp_ignore_bogus_error_responses=1 "  >>  /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.icmp_echo_igNore_broadcasts" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.icmp_echo_igNore_broadcasts = 1"  >>  /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.log_martians" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.log_martians = 1 " >>  /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.default.log_martians" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.default.log_martians = 1 " >>  /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi
cat /etc/sysctl.conf  |grep "net.ipv4.icmp_igNore_bogus_error_messages" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.icmp_igNore_bogus_error_messages = 1 "  >>  /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.tcp_syncookies" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv6.conf.all.accept_ra" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv6.conf.all.accept_ra = 0  " >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv6.conf.default.accept_ra" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv6.conf.default.accept_ra = 0 "  >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv6.conf.all.accept_redirects" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv6.conf.all.accept_redirects = 0 " >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv6.conf.default.accept_redirects" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv6.conf.default.accept_redirects = 0 " >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv6.conf.all.disable_ipv6" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv6.conf.all.disable_ipv6 = 1 " >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "kernel.exec-shield" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "kernel.exec-shield = 1" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "kernel.randomize_va_space" #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "kernel.sysrq"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "kernel.sysrq = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi


cat /etc/sysctl.conf  |grep "net.bridge.bridge-nf-call-ip6tables"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.bridge.bridge-nf-call-ip6tables = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.bridge.bridge-nf-call-iptables"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.bridge.bridge-nf-call-iptables = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.bridge.bridge-nf-call-arptables"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.bridge.bridge-nf-call-arptables = 0" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "kernel.msgmnb"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "kernel.msgmnb = 65536" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "kernel.msgmax"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "kernel.msgmax = 65536" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.arp_ignore"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.arp_ignore = 1" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.conf.all.arp_announce"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.conf.all.arp_announce = 2" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.ip_local_port_range"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.ip_local_port_range = 32768 61000" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

cat /etc/sysctl.conf  |grep "net.ipv4.ip_local_reserved_ports"  #2> | echo -e '\033[32m this Kernel parameter is \033[1;32m EXIST\033[0m'
if [ $? -eq 1 ] ; then
echo "net.ipv4.ip_local_reserved_ports = 50010,50020,50030,50060,50070,50075,50090,50111,54322,55432,55433,56666,60080,60140,60843,63000,63100,63313" >> /etc/sysctl.conf #2> /dev/null 1> /dev/null
fi

}
main_nine() {
        function10
}
main_nine 2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG
sysctl  -p > /dev/null 2>&1


echo "#######################IP route flush#####################################\n" >> $HARD_LOG

echo -e "#CIS 3.1.1 IP route flush"
echo -e "#CIS 3.1.1 IP route flush"
 >> $HARD_LOG
/sbin/sysctl -w net.ipv4.route.flush=1
/sbin/sysctl -p /etc/sysctl.conf

#######################Audit Rules #####################################


echo -e "#CIS 3.1.1 4.1.2 Audit Rules"
echo -e "#CIS 3.1.1 4.1.2 Audit Rules"
 >> $HARD_LOG

if [ ! -f /var/log/wtmp ] ;then
touch /var/log/wtmp #2> /dev/null 1> /dev/null
fi
if [ ! -f /var/log/btmp ] ;then
touch /var/log/btmp #2> /dev/null 1> /dev/null
fi
cat /etc/audit/audit.rules  |grep "session"
if [ $? -eq 1 ] ; then
echo "-w /var/log/wtmp -p wa -k session" >> /etc/audit/audit.rules #2> /dev/null 1> /dev/null
echo -en "$(date +%d%b%Y" "%r) : WTMP RULE  in /etc/audit/audit.rules \n" >> $HARD_LOG	
echo "-w /var/log/btmp -p wa -k session" >> /etc/audit/audit.rules #2> /dev/null 1> /dev/null
echo -en "$(date +%d%b%Y" "%r) : BTMP  RULE  in /etc/audit/audit.rules \n" >> $HARD_LOG	
/etc/init.d/auditd restart
fi
wait "Updating" "audit.rules" "DONE"

########Check if auditd services is running#########
chkconfig --level 0123456 auditd on
systemctl enable auditd.service
systemctl status  auditd.service



echo "##################################################################################\n" >> $HARD_LOG

echo -en "$(date +%d%b%Y" "%r) :\tDNS Settings\n" >> $HARD_LOG

echo 'options attempts: 2
options timeout: 1

search ril.com' >/etc/resolv.conf
echo "search in.ril.com" >>/etc/resolv.conf
echo -en "nameserver $NS1\n" >>/etc/resolv.conf
echo -en "nameserver $NS2\n" >>/etc/resolv.conf

echo -en "$(date +%d%b%Y" "%r) : Update /etc/resolv.conf file with $NS1, $NS2 \n" | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG

echo -en  "##################################DNS SETTING DONE##################################################\n" >> $HARD_LOG


###################PAM Configuration setting #################################


#echo "#CIS PAM configuration 5.6"
#echo "#CIS PAM configuration 5.6" >> $HARD_LOG



####edit the line with Follwing value###
echo -e "#CIS  1.1.5 Setting for Noexec,Nosuid,Nodev of /tmp"
echo -e "#CIS  1.1.5 Setting for Noexec,Nosuid,Nodev of /tmp" >> $HARD_LOG

cd /etc/
cp -p fstab /etc/stab.prehard
sed -i '/tmp\s/ s/defaults/Noexec,Nosuid,Nodev/' /etc/fstab

#########################configure rsyslog file ##########################

echo -e "#CIS 4.2.1  Rsyslog setting"
echo -e "#CIS 4.2.1  Rsyslog setting">> $HARD_LOG

echo -en "##################################################################################\n" >> $HARD_LOG
echo -en "#                     Rsyslog setting                                            #\n" >> $HARD_LOG
echo -en "##################################################################################\n" >> $HARD_LOG

cp -p /etc/rsyslog.conf /etc/rsyslog.conf.prehard
echo "# The authpriv file has restricted access." >> /etc/rsyslog.conf
echo "auth.*,user.*	/var/log/messages" >> /etc/rsyslog.conf


###########################################################################################
echo -e "#CIS 5.1.8 setting"
echo -e "#CIS 5.1.8 at.allow setting">> $HARD_LOG


### Restrict at and cron for Authorized Users
echo -e "#CIS  5.1.8 Checking for at.allow  cron.deny"
echo -e "#CIS  5.1.8 Checking for at.allow  cron.deny" >> $HARD_LOG

wait "Removing" "CRON.DENY" "DONE"
	`which rm` -f /etc/cron.deny | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG
wait "Removing" "AT.DENY" "DONE"
	`which rm` -f /etc/at.deny | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG

function9 () {
#--------------------------------------------------
### CRON.ALLOW 
#--------------------------------------------------
wait "Verifying" "CRON.ALLOW" "DONE"
CRNALL='/etc/cron.allow'
CRNAT='/etc/at.allow'
if [ ! -f "$CRNALL" ];then
	touch /etc/cron.allow
#--------------------------------------------------
#	echo "$CRNALL has been created" 
#--------------------------------------------------
wait "Created" "CRON.ALLOW" "DONE"
	echo "root" >> /etc/cron.allow

wait "Added root" "CRON.ALLOW" "DONE"

	chmod 400 /etc/cron.allow 
wait "CHMOD on" "CRON.ALLOW" "DONE"
fi
#--------------------------------------------------
### AT.ALLOW
#--------------------------------------------------
wait "Verifying" "AT.ALLOW" "DONE"
if [ ! -f "$CRNAT" ];then
	echo -e  `touch /etc/at.allow`
#--------------------------------------------------
#	echo "$CRNAT has been created "
#--------------------------------------------------
wait "Created" "AT.ALLOW" "DONE"
	chmod 0644 /etc/at.allow
wait "CHMOD on" "AT.ALLOW" "DONE"
	echo "root" >> /etc/at.allow
wait "Added root" "AT.ALLOW" "DONE"
fi
}
main_eight() {
	function9
}
main_eight 2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG

chmod 0644 /etc/at.allow



#########################################

echo -e "Permission, change and Modify owner and group"
echo -e "Permission, change and Modify owner and group">> $HARD_LOG

echo -en  "###############CIS 1.4.1,5.1.4,5.1.3,5.1.4,5.1.5,5.1.6,5.1.8,5.2.1,4.2.1.2,1.7.1.4,1.7.1.5,1.7.1.6,6.1.2,6.1.3,6.1.5,6.1.8,4.1.9,4.1.8,5.1.8 Ownership of root file  ######################################\n"  >> $HARD_LOG
function3 () {
ownership_root=('/etc/grub.conf' '/etc/cron.d' '/etc/cron.hourly' '/etc/cron.daily' '/etc/cron.weekly' '/etc/cron.monthly' '/etc/cron.allow' '/etc/ssh/sshd_config' '/etc/rsyslog.conf' '/etc/motd' '/etc/issue' '/etc/issue.net' '/etc/passwd' '/etc/shadow' '/etc/gshadow' '/etc/group' '/var/log/btmp' '/var/log/lastlog' '/var/log/messages' '/var/log/sa' '/var/log/samba' '/etc/cron.allow' '/etc/at.allow')
for ownership in ${ownership_root[@]}
        do
        chown -R root:root $ownership > /dev/null 2>&1
        done

}
main_two() {
	function3
}
main_two 2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG
echo -en  "###############Ownership of root file  ######################################\n"  >> $HARD_LOG

###############################################################################
echo -e "#CIS  5.1.3,5.1.4,5.1.5,5.1.6,5.1.8  Set for file permissions"
echo -e "#CIS  5.1.3,5.1.4,5.1.5,5.1.6,5.1.8  Set for file permissions" >> $HARD_LOG

function7 () {
perm_cron=('/etc/cron.hourly' '/etc/cron.daily' '/etc/cron.weekly' '/etc/cron.monthly' '/etc/cron.allow')
for permcr in ${perm_cron[@]}
        do
        chmod -R og-rwx  $permcr  > /dev/null 2>&1
        done
}
main_six() {
        function7
}
main_six  2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG
##########################################################################################

echo -e "#CIS 6.1.3,6.1.5,5.1.2 Set for file permissions"
echo -e "#CIS 6.1.3,6.1.5,5.1.2 Set for file permissions" >> $HARD_LOG

function6 () {
perm_readonly=('/etc/at.allow' '/etc/cron.allow' '/etc/gshadow' '/etc/shadow')
for perm_read in ${perm_readonly[@]}
        do
        chmod -R 0400 $perm_read  > /dev/null 2>&1
        done
}
main_five() {
        function6
}
main_five  2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG



echo -e "#CIS 5.1.8,5.2.1,4.1.9,4.2.1.2 Set for file permissions"
echo -e "#CIS 5.1.8,5.2.1,4.1.9,4.2.1.2 Set for file permissions"  >> $HARD_LOG

function4 () {
perm_rw=('/etc/cron.d' '/etc/ssh/sshd_config' '/var/log/wtmp' '/etc/securetty' '/var/log/messages' '/wtmp')
        for perRW in ${perm_rw[@]}
        do
        chmod -R 0600 $perRW  > /dev/null 2>&1
        done
}
main_three() {
        function4
}
main_three  2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG

echo -e "#CIS 1.7.1.4,1.7.1.5,1.7.1.6,6.1.4,6.1.2,5.1.2,3.4.4,3.4.5 Set for file permissions"
echo -e "#CIS 1.7.1.4,1.7.1.5,1.7.1.6,6.1.4,6.1.2,5.1.2,3.4.4,3.4.5 Set for file permissions" >> $HARD_LOG

function5 () {
perm_r=('/etc/motd' '/etc/issue' '/etc/issue.net' '/etc/group' '/etc/passwd' '/var/log/btmp' '/var/log/sa' '/var/log/samba' '/etc/crontab' '/etc/inittab' '/etc/hosts.allow' '/etc/hosts.deny' '/etc/sysctl.conf' '/var/log/btmp' '/var/log/lastlog' '/var/log/sa' '/var/log/samba' '/var/spool/cron/')
for permread in ${perm_r[@]}
        do
        chmod -R 0644 $permread > /dev/null 2>&1
        done
}
main_four() {
        function5
}
main_four  2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG
echo -en

chmod 0700 /etc/rsyslog.conf

function8 () {
     perm_ex=('/etc/abrt' '/var/lib/nfs' '/etc/pam.d')
     for permex in ${perm_ex[@]}
             do
             chmod -R 0750 $permex > /dev/null 2>&1
             done
 }
main_seven() {
         function8
}
main_seven  2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}"; done >> $HARD_LOG

chmod 0751 /etc/sysconfig/
chmod 0751 /var/log/
#chmod 0777 /etc/cron.deny


##############################################################################
service sysstat restart
/bin/systemctl  restart  sysstat.service
chkconfig --level 0123456 sysstat on
systemctl enable sysstat.service

chmod 0600 /var/log/wtmp
echo "/sbin/chmod 0600 /var/log/wtmp" >> /etc/rc.local


echo "********************************************************************************">> ${HARD_LOG}
echo "CIS 5.4.1.1 Setting Password Expiry Time for users ..." >> ${HARD_LOG}
cp /etc/login.defs /etc/login.defs.prehard
cd /etc
sed -e 's/99999/45/g' login.defs > login.defs1
cp login.defs login.defs.before
mv login.defs1 login.defs
/bin/sed -e 's/PASS_MIN_LEN\s5/PASS_MIN_LEN\t8/g' login.defs > login.defs1
cp login.defs login.defs.before
mv login.defs1 login.defs

#####################################################################
#####################\n" >> $HARD_LOG
echo -en "#  CIS  3.1 changing UMASK                                             #\n" >> $HARD_LOG
echo -en "##################################################################################\n" >> $HARD_LOG
functionA() {
sed -i 's/umask 0027/umask 027/g' /root/.bash_profile
sed -i 's/umask 0022/umask 027/g' /root/.bash_profile
sed -i 's/umask 022/umask 027/g' /root/.bash_profile
sed -i '${s/$/'"\numask 027"'/;}' /root/.bash_profile
wait "Parameter" "UMASK" "DONE"
sed -i 's/umask 002/umask 022/g'  /etc/bashrc
sed -i '${s/$/'"\numask 022"'/;}' /etc/bashrc
sed -e 's/umask 022/umask 027/g'  /etc/functions
`which source` /root/.bash_profile
}
mainA ()
{
	functionA
}
mainA 2>&1 | while read line ; do echo "$(date +%d%b%Y" "%r) : ${line}";done >> $HARD_LOG

cat > /etc/bashrc <<EOF
if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
  PS1="\\[$(tput setaf 6)\\][\\u@\\h:\\w] #\\[$(tput sgr0)\\]"
else # normal
  PS1="\\[$(tput setaf 2)\\][\\u@\\h:\\w] $\\[$(tput sgr0)\\]"
fi
EOF

echo "umask 022" >> /etc/bashrc

######################################SSH FILE #########################

sed -i 's/#Protocol 2/Protocol 2/g'  /etc/ssh/sshd_config

################### YUM CONFIGURATION ##################################

#cd /etc/yum.repos.d/
#mv * /etc/BackupSystemFiles/backup.repo.prehard
#echo "Files have been copied to /etc/BackupSystemFiles " >>${HARD_LOG}

echo "##########################ADDITIONAL LINES############################" >>//etc/security/limits.conf
echo "*                soft    core            unlimited" >>//etc/security/limits.conf

######################################### RUNLEVEL#########################

echo " #######Change the default runlevel to multi user without X###############"
cd /etc/systemd/system
ls -l /etc/systemd/system/default.target | grep graphical.target
unlink default.target
echo "###Setting multiuser target#####"
ln  -s  /usr/lib/systemd/system/multi-user.target  default.target
ls -l /etc/systemd/system/default.target

######## disable the ctrl + Alt + delete key combination, #################################

ln -sf /dev/null /etc/systemd/system/ctrl-alt-del.target
systemctl mask ctrl-alt-del.target


echo "##################################################################################\n" >> $HARD_LOG

echo -en "RIL NTP Settings\n" >> $HARD_LOG
yum install ntp* -y
cp -pv /etc/ntp.conf /etc/ntp.conf.prehard
sed -e "s/^server/#server/g" /etc/ntp.conf > test ; cat test > /etc/ntp.conf
echo "server  time.ril.com" >> /etc/ntp.conf
rm -rf test
/usr/sbin/ntpd -u ntp:ntp -g
ntpq -p
timedatectl set-ntp true
hwclock --systohc --utc
systemctl enable ntpd.service
systemctl restart ntpd
systemctl status ntpd
systemctl status ntpd >> $HARD_LOG

echo -e  "##################################NTP SETING DONE##################################################\n" >> $HARD_LOG

echo "##########################ADDITIONAL LINES##########################" >> //etc/security/limits.conf
echo "*                soft    core            unlimited" >>//etc/security/limits.conf
adduser idcadm
echo "idcadm    ALL=(ALL)       ALL" >> /etc/sudoers
echo "umask 0022" >> /root/.cshrc
echo "All the activities are done by this script has been logged into $HARD_LOG"
for i in idcadm ; do useradd -ou 0 -g 0 $i; echo \ROX13r\!l5 | passwd --stdin $i ; done

echo -e "##################################################################################\n" >> $HARD_LOG

echo -e "####globally desable CAD############\n" >> $HARD_LOG 
echo "logout=' '" > /etc/dconf/db/local.d/00-disable-CAD
echo -e "[org/gnome/settings-daemon/plugins/media-keys]" >> /etc/dconf/db/local.d/00-disable-CAD

systemctl restart ntpd
systemctl set-default multi-user.target 
chmod 0751 /etc/sysconfig
chmod 0644 /etc/passwd
chmod 0755 /
chmod -R 0700 /etc/rc.d/init.d


echo -e  "##################################REMOVE SUIDs FROM FILES##################################################\n" >> $HARD_LOG
cat > remove-suid <<EOF
/usr/libexec/openssh/ssh-keysign
/usr/libexec/pt_chown
/usr/bin/wall
/usr/bin/gpasswd
/usr/bin/write
/usr/bin/chfn
/usr/bin/newgrp
/usr/bin/chsh
/usr/sbin/userhelper
/usr/sbin/usernetctl
/bin/traceroute
/bin/umount
/bin/mount
/sbin/netreport
EOF

for i in `cat remove-suid` ;do chmod -s $i ;done
rm -rf remove-suid


echo -e "##################################################################################\n" >> $HARD_LOG

echo -e  "##################################AUDIT RULES##################################################\n" >> $HARD_LOG

# /etc/audit/audit.rules
cat << 'EOF' >> /etc/audit/audit.rules


# CIS Benchmark Adjustments


# CIS 5.2.4
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-a always,exit -F arch=b32 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change


# CIS 5.2.5
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity


# CIS 5.2.6
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale


# CIS 5.2.7
-w /etc/selinux/ -p wa -k MAC-policy


# CIS 5.2.8
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /var/log/tallylog -p wa -k logins


# CIS 5.2.9
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session


# CIS 5.2.10
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=429496 7295 -k perm_mod
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 -F auid!=429496 7295 -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod
-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod


# CIS 5.2.11
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access
-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access


# CIS 5.2.13
-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts


# CIS 5.2.14
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete


# CIS 5.2.15
-w /etc/sudoers -p wa -k scope


# CIS 5.2.16
-w /var/log/sudo.log -p wa -k actions


# CIS 5.2.17
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module -S delete_module -k modules
-a always,exit -F arch=b32 -S init_module -S delete_module -k modules
EOF


# CIS 5.2.12
echo -e "\n# CIS 5.2.12" >> /etc/audit/audit.rules
find PART -xdev \( -perm -4000 -o -perm -2000 \) -type f | awk '{print "-a always,exit -F path=" $1 " -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged" }' >> /etc/audit/audit.rules


# CIS 5.2.18
echo -e "\n# CIS 5.2.18"
echo "-e 2" >> /etc/audit/audit.rules


# CIS 2.1.12
chkconfig chargen-dgram off
# CIS 2.1.13
chkconfig chargen-stream off
# CIS 2.1.14
chkconfig daytime-dgram off
# CIS 2.1.15
chkconfig daytime-stream off
# CIS 2.1.16
chkconfig echo-dgram off
# CIS 2.1.17
chkconfig echo-stream off
# CIS 2.1.18
chkconfig tcpmux-server off


# CIS 3.1
echo "\n# CIS Benchmarks"
echo "umask 027" >> /etc/sysconfig/init


# CIS 3.3
chkconfig avahi-daemon off
# CIS 3.4
chkconfig cups off
# CIS 3.6 (ntp.conf defaults meet requirements)
chkconfig ntpd on
# CIS 3.16 (postfix defaults meet requirements)
chkconfig sendmail off
alternatives --set mta /usr/sbin/sendmail.postfix
chkconfig postfix on
# CIS 5.1.3
chkconfig syslog off && chkconfig rsyslog on
# CIS 5.2.2
chkconfig auditd on
# CIS 6.1.2
chkconfig crond on


# CIS 6.2.4
sed -i 's/^#X11Forwarding no$/X11Forwarding no/' /etc/ssh/sshd_config
sed -i '/^X11Forwarding yes$/d' /etc/ssh/sshd_config
# CIS 6.2.5
sed -i 's/^.*MaxAuthTries.*$/MaxAuthTries 4/' /etc/ssh/sshd_config
# CIS 6.2.8
#sed -i 's/^#PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config
# CIS 6.2.11
echo -e "\n# CIS Benchmarks\n# CIS 6.2.12" >> /etc/ssh/sshd_config
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> /etc/ssh/sshd_config
# CIS 6.2.12
sed -i 's/^.*ClientAliveInterval.*$/ClientAliveInterval 300/' /etc/ssh/sshd_config
sed -i 's/^.*ClientAliveCountMax.*$/ClientAliveCountMax 0/' /etc/ssh/sshd_config


# CIS 6.3.2
sed -i 's/password.+requisite.+pam_cracklib.so/password required pam_cracklib.so try_first_passretry=3 minlen=14,dcredit=-1,ucredit=-1,ocredit=-1 lcredit=-1/' /etc/pam.d/system-auth
# CIS 6.3.3
sed -i -e '/pam_cracklib.so/{:a;n;/^$/!ba;i\password    requisite     pam_passwdqc.so min=disabled,disabled,16,12,8' -e '}' /etc/pam.d/system-auth
# CIS 6.3.6
sed -i 's/^\(password.*sufficient.*pam_unix.so.*\)$/\1 remember=5/' /etc/pam.d/system-auth
# CIS 6.5
sed -i 's/^#\(auth.*required.*pam_wheel.so.*\)$/\1/' /etc/pam.d/su



echo -e  "##################################BONDING##################################################\n" >> $HARD_LOG

echo -e "##### For BONDING PROVIDE INTERFACES WHICH ARE TO BE SET AS SLAVES AND ESSENTIAL INFORMATION ####"

echo "############################################################"
read -p "Are you sure you want to Check Link Status of NIC...? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
echo -e "##################################################"
echo -e "Checking Link Status and Speed of Interfaces...!!!\n"
sleep 1
/bin/ls -l /etc/sysconfig/network-scripts/ifcfg-* | awk -F' ' '{print$9}' | cut -d- -f3 > inter
for i in `cat inter`
do
echo -e "\n"
echo "==============================="
echo "Details of Interface $i , KINDLY REMEMBER WHICH INTERFACES YOU WANT TO SET AS SLAVES"
echo "==============================="
ethtool $i  | grep -E 'Link detected:|Speed' ; sleep 2; done
read -p "Are you sure you want to Proceed Bonding...? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
echo -e "##################################################"
echo -e "Created new Directory /opt/NWinterfaces for Backup of files of ifcfg-* interfaces\n"
sleep 2
mkdir /opt/NWinterfaces
cp /etc/sysconfig/network-scripts/ifcfg-eth* /opt/NWinterfaces
cp /etc/sysconfig/network-scripts/ifcfg-ens* /opt/NWinterfaces
cp /etc/sysconfig/network-scripts/ifcfg-p* /opt/NWinterfaces
cp /etc/sysconfig/network-scripts/ifcfg-em* /opt/NWinterfaces
modprobe --first-time bonding
read $NEWFILE -p "ENTER 1st INTERFACE FILE NAME:" b
/bin/echo "DEVICE=$b
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
USERCTL=no" > /etc/sysconfig/network-scripts/ifcfg-$b
sleep 1
read $NEWFILE -p "ENTER 2st INTERFACE FILE NAME:" b
/bin/echo "DEVICE=$b
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
USERCTL=no" > /etc/sysconfig/network-scripts/ifcfg-$b
sleep 1
/bin/touch /etc/sysconfig/network-scripts/ifcfg-bond0
/bin/echo "DEVICE=bond0
USERCTL=no
BOOTPROTO=none
ONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-bond0
read $IPADDR -p "ENTER The IPADDR:" a
echo IPADDR=$a  >> /etc/sysconfig/network-scripts/ifcfg-bond0
read $GEATWAY -p "ENTER The GATEWAY:" a
echo GATEWAY=$a  >> /etc/sysconfig/network-scripts/ifcfg-bond0
read $NETMASK -p "ENTER The NETMASK:" a
echo NETMASK=$a  >> /etc/sysconfig/network-scripts/ifcfg-bond0
read $BONDING_OPTS -p "ENTER The Bonding MODE:" b
#echo  BONDING_OPTS=\"mode=$b miimon=100\"  >> /etc/sysconfig/network-scripts/ifcfg-bond0
/bin/echo "alias bond0 bonding
options bond0 mode=$b miimon=100" > /etc/modprobe.d/bonding.conf


sleep 1
/sbin/modprobe bonding
/etc/init.d/network restart
sleep 2
/bin/cat /proc/net/bonding/bond0
fi
fi
exit 0

echo "Bonding is done"
echo "#======================================================================#"
echo "END OF THE SCRIPT"
echo "#======================================================================#"
