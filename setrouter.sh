#Author:Melonsis - tch1995@live.com
#This file including codes written by miao1007.
#Using GPL agreement. NOT for commercial use. especially TAOBAO.

#Please set your own gateway first. See the method in readme.md.
GATEWAY="172.18.124.1"

#set network
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
uci commit network

#Because of the official website of PandoraBox was closed, this part of scripts will change opkg sources for you.
#Attention: When you using this part, you must check the version of your Pandorabox first. See readme.md.
cp /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.bak
echo > /etc/opkg/distfeeds.conf
echo 'src/gz 17.08_core http://mirrors.moekr.com/pandorabox/17.11/targets/ralink/mt7621/packages' >> /etc/opkg/distfeeds.conf
echo 'src/gz 17.08_base http://mirrors.moekr.com/pandorabox/17.11/packages/mipsel_1004kc_dsp/base' >> /etc/opkg/distfeeds.conf
echo 'src/gz 17.08_lafite http://mirrors.moekr.com/pandorabox/17.11/packages/mipsel_1004kc_dsp/lafite' >> /etc/opkg/distfeeds.conf
echo 'src/gz 17.08_luci http://mirrors.moekr.com/pandorabox/17.11/packages/mipsel_1004kc_dsp/luci' >> /etc/opkg/distfeeds.conf
echo 'src/gz 17.08_mtkdrv http://mirrors.moekr.com/pandorabox/17.11/packages/mipsel_1004kc_dsp/mtkdrv' >> /etc/opkg/distfeeds.conf
echo 'src/gz 17.08_newifi http://mirrors.moekr.com/pandorabox/17.11/packages/mipsel_1004kc_dsp/newifi' >> /etc/opkg/distfeeds.conf
echo 'src/gz 17.08_packages http://mirrors.moekr.com/pandorabox/17.11/packages/mipsel_1004kc_dsp/packages' >> /etc/opkg/distfeeds.conf
opkg update