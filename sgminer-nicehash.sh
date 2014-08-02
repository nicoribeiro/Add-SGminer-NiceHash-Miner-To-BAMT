#!/bin/sh
mine stop
sleep 5
mkdir /opt/miners/sgminer-nicehash
cd /opt/miners/sgminer-nicehash
bits=$(/usr/bin/getconf LONG_BIT)
if (( $bits == 32 )); then
	file=sgminer-5.0-pre-release-2014-07-20-linux-i386.zip 
else
	file=sgminer-5.0-pre-release-2014-07-20-linux-amd64.zip
fi
wget https://www.nicehash.com/software/$file
unzip $file


patch /etc/bamt/bamt.conf <<.
116a117
>   cgminer_opts: --api-listen --config /etc/bamt/sgminer-nicehash.conf
124a126
>   # Sgminer NiceHash - Multi-Algo
130a133
>   miner-sgminer-nicehash: 1
.


patch /opt/bamt/common.pl <<.
1477a1478,1480
>       } elsif (\${\$conf}{'settings'}{'miner-sgminer-nicehash'}) {
>         \$cmd = "cd /opt/miners/sgminer-5/;/usr/bin/screen -d -m -S sgminer-nicehash /opt/miners/sgminer-nicehash/sgminer \$args";
>         \$miner = "sgminer-nicehash";
.


cd /etc/bamt/
mv /tmp/config.patch /etc/bamt/
cd /etc/bamt/
patch /etc/bamt/sgminer-5.conf < config.patch
rm config.patch

sync
echo 'SGMiner NiceHash Installed.'
echo 'Please review your /etc/bamt/bamt.conf to enable. (set cgminer: 0, miner-sgminer-* : 0 and miner-vertminer-* : 0)'
echo 'Configure /etc/bamt/sgminer-nicehash.conf with your values.'