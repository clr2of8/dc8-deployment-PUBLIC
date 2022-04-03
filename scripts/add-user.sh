#!/bin/bash
sudo su -c "useradd art -s /bin/bash -m"
sudo chpasswd << 'END'
art:AtomicRedTeam1!
usermod -aG sudo art
