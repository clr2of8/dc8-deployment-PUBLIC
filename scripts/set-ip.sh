#!/bin/bash
ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
sed -i -r "s/VECTR_HOSTNAME\=.*$/VECTR_HOSTNAME=$ip/g" /opt/vectr/.env
docker-compose down
docker-compose up -d
