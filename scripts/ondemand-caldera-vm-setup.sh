#!/bin/bash
echo "****Installing Git,pip3,curl****"
apt update
apt install git python3-pip curl -y

echo "****Adding the 'art' user****"
# perl -e "print crypt('AtomicRedTeam1\!','password')"
useradd -m -s /usr/bin/bash -p paBQOnbelncTY art
echo "art ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "****Installing GO****"
cd /home/art
curl -OL https://golang.org/dl/go1.17.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.17.7.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/art/.profile

echo "****Installing MITRE CALDERA v4.0.0-beta****"
sudo apt install upx -y
git clone https://github.com/mitre/caldera.git --recursive --branch 4.0.0-beta
cd caldera
sudo pip3 install -r requirements.txt
# Downgrade markupsafe version to fix bug
sudo pip3 install markupsafe==2.0.1
wget https://raw.githubusercontent.com/clr2of8/dc8-deployment-PUBLIC/master/caldera/local.yml -O /home/art/caldera/conf/local.yml
# hacks for v4.0.0-beta training modules
sed -i s/op.finish[[:space:]]and[[:space:]]//g /home/art/caldera/plugins/training/app/flags/operations/flag_*
sed -i s/[[:space:]]and[[:space:]]op.finish//g /home/art/caldera/plugins/training/app/flags/plugins/manx/flag_0.py
sed -i s/op.finish[[:space:]]and[[:space:]]//g /home/art/caldera/plugins/training/app/flags/plugins/mock/flag_*
chown -R art:art /home/art/caldera


echo "****Installing VECTR v8.2.2****"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose unzip -y
sudo apt upgrade -y
sudo systemctl enable docker
sudo docker-compose down
mkdir -p /opt/vectr
cd /opt/vectr
wget https://github.com/SecurityRiskAdvisors/VECTR/releases/download/ce-8.2.2/sra-vectr-runtime-8.2.2-ce.zip -P /opt/vectr
unzip -o sra-vectr-runtime-8.2.2-ce.zip
docker-compose down
docker-compose up -d
docker-compose down
# add crontab to start VECTR after boot
wget https://raw.githubusercontent.com/clr2of8/dc8-deployment-PUBLIC/master/scripts/set-ip.sh -O /opt/vectr/set-ip.sh
chmod +x /opt/vectr/set-ip.sh
croncmd="sleep 30 && sudo /opt/vectr/set-ip.sh"
cronjob="@reboot $croncmd"
( crontab -l -u art | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -u art -

# Manual steps
# * sudo apt-get -y install xfce4
# * add art user to VECTR
# * userdel ubuntu
# * turn off lock screen
# * add bookmarks for caldera and vectr on localhost?

echo "****Done with OnDemand Caldera Linux VM Setup****"
echo "****Restart this VM and log in as user:art password:AtomicRedTeam1!****"
