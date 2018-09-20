#!/bin/ash
#Author:Melonsis Tan- tch1995@live.com
#This file including codes written by miao1007.
#Using GPL agreement. NOT for commercial use. especially TAOBAO.
check_ip() {
    IP=$1
    if  echo $IP |grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$"|grep -v "\.0[0-9]\{1,2\}"|grep -v "^0[0-9]\{1,2\}" ||  (echo -e "[\e[1;31m FAILED \e[0m] \c"&&echo "Gateway format error! [ERROR 1]"&& return 1) ; then
        FIELD1=$(echo $IP|cut -d. -f1)
        FIELD2=$(echo $IP|cut -d. -f2)
        FIELD3=$(echo $IP|cut -d. -f3)
        FIELD4=$(echo $IP|cut -d. -f4)
        if [ $FIELD1 -le 255 -a $FIELD2 -le 255 -a $FIELD3 -le 255 -a $FIELD4 -le 255 ]; then
                echo -e "[\e[1;32m OK \e[0m] \c"
		echo "Gateway $IP seems available. Turn to next stage."
        else
            echo -e "[\e[1;31m FAILED \e[0m] \c"
	    echo "Gateway $IP seems not available! Please check again.[ERROR 2]"
            exit
	 fi
      else
	exit
    fi
}
defGATEWAY="172.18.124.1"
GATEWAY=$1;
clear
echo "======CQUPT PandoraBox Setting Tools V0.2======"
if test -z $GATEWAY
	then
		echo "NO gateway detected. Using default..."		
		GATEWAY=$defGATEWAY
fi
check_ip $GATEWAY

#set network
echo -e "[\e[1;32m STAGE1 \e[0m] \c"
echo "Starting to setting a new port for PPPoE..."
exit
uci delete network.wan6
uci commit network

uci set network.netkeeper=interface
uci set network.netkeeper.ifname=$(uci show network.wan.ifname | awk -F "'" '{print $2}')
uci set network.netkeeper.macaddr=aabbccddeeff
uci set network.netkeeper.proto=pppoe
uci set network.netkeeper.username=username
uci set network.netkeeper.password=password
uci set network.netkeeper.metric='0'
uci set network.netkeeper.auto='0'
uci commit network

#set firewall
echo -e "[\e[1;32m STAGE2 \e[0m] \c"
echo "Setting firewall..."
uci set firewall.@zone[1].network='wan netkeeper' 
uci commit firewall
/etc/init.d/firewall restart
/etc/init.d/network reload
/etc/init.d/network restart

#enable \r in PPPoE
cp /lib/netifd/proto/ppp.sh /lib/netifd/proto/ppp.sh_bak
sed -i '/proto_run_command/i username=`echo -e "$username"`' /lib/netifd/proto/ppp.sh

#Setting route to allow you enter CQUPT network(like jwzx)
#Attention: you need to use "ipconfig -all" in your PC to find out your own gateway first.
echo -e "[\e[1;32m STAGE3 \e[0m] \c"
echo "Setting static router table..."
uci add network route
uci set network.@route[0]=route
uci set network.@route[0].interface='wan'
uci set network.@route[0].target='202.202.32.0'
uci set network.@route[0].netmask='255.255.240.0'
uci set network.@route[0].gateway=$GATEWAY

uci add network route
uci set network.@route[1]=route
uci set network.@route[1].interface='wan'
uci set network.@route[1].target='172.16.0.0'
uci set network.@route[1].netmask='255.224.0.0'
uci set network.@route[1].gateway=$GATEWAY

uci add network route
uci set network.@route[2]=route
uci set network.@route[2].interface='wan'
uci set network.@route[2].target='172.32.0.0'
uci set network.@route[2].netmask='255.254.0.0'
uci set network.@route[2].gateway=$GATEWAY

uci add network route
uci set network.@route[3]=route
uci set network.@route[3].interface='wan'
uci set network.@route[3].target='211.83.208.0'
uci set network.@route[3].netmask='255.255.240.0'
uci set network.@route[3].gateway=$GATEWAY

uci add network route
uci set network.@route[4]=route
uci set network.@route[4].interface='wan'
uci set network.@route[4].target='222.177.140.0'
uci set network.@route[4].netmask='255.255.255.128'
uci set network.@route[4].gateway=$GATEWAY

uci add network route
uci set network.@route[5]=route
uci set network.@route[5].interface='wan'
uci set network.@route[5].target='219.153.62.64'
uci set network.@route[5].netmask='255.255.255.192'
uci set network.@route[5].gateway=$GATEWAY

uci add network route
uci set network.@route[6]=route
uci set network.@route[6].interface='wan'
uci set network.@route[6].target='10.10.10.0'
uci set network.@route[6].netmask='255.255.255.0'
uci set network.@route[6].gateway=$GATEWAY

uci add network route
uci set network.@route[7]=route
uci set network.@route[7].interface='wan'
uci set network.@route[7].target='172.22.0.0'
uci set network.@route[7].netmask='255.254.0.0'
uci set network.@route[7].gateway=$GATEWAY

uci add network route
uci set network.@route[8]=route
uci set network.@route[8].interface='wan'
uci set network.@route[8].target='172.20.0.0'
uci set network.@route[8].netmask='255.255.0.0'
uci set network.@route[8].gateway=$GATEWAY

uci commit network

clear
echo "Seems all done. Enjoy your PandoraBox!"