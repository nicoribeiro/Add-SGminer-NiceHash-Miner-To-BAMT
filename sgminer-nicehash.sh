#!/bin/sh
mine stop
sleep 5

# copy sgminer conf file
cp sgminer-nicehash.conf /etc/bamt/.

# Download NiceHash patched sgminer
mkdir /opt/miners/sgminer-nicehash
cd /opt/miners/sgminer-nicehash
bits=$(/usr/bin/getconf LONG_BIT)
if (( $bits == 32 )); then
	file=sgminer-5.0-pre-release-2014-07-20-linux-i386.zip 
else
	file=sgminer-5.0-pre-release-2014-07-20-linux-amd64.zip
fi
wget https://www.nicehash.com/software/$file --no-check-certificate
unzip $file

# patch bamt.conf
patch /etc/bamt/bamt.conf <<.
116a117
>   cgminer_opts: --api-listen --config /etc/bamt/sgminer-nicehash.conf
124a126
>   # Sgminer NiceHash - Multi-Algo
130a133
>   miner-sgminer-nicehash: 1
.

# patch common.pl
patch /opt/bamt/common.pl <<.
1477a1478,1480
>       } elsif (\${\$conf}{'settings'}{'miner-sgminer-nicehash'}) {
>         \$cmd = "cd /opt/miners/sgminer-5/;/usr/bin/screen -d -m -S sgminer-nicehash /opt/miners/sgminer-nicehash/sgminer \$args";
>         \$miner = "sgminer-nicehash";
.


sync
echo 'SGMiner NiceHash Installed.'
echo 'Please review your /etc/bamt/bamt.conf to enable. (set cgminer: 0, miner-sgminer-* : 0 and miner-vertminer-* : 0)'
echo 'Configure /etc/bamt/sgminer-nicehash.conf with your values.'