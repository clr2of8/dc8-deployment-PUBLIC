#!/bin/bash
echo "****Adding the 'art' user****"
sudo su -c "useradd art -s /bin/bash -m"
sudo chpasswd << 'END'
art:AtomicRedTeam1!
END
usermod -aG sudo art
