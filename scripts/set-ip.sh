#!/bin/bash
ip=`curl ipconfig.io`
sed -i -r "s/VECTR_HOSTNAME\=.*$/VECTR_HOSTNAME=$ip/g" /opt/vectr/.env
