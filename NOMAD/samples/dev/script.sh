#!/bin/bash

# update os packages
apt-get update
apt-get upgrade -y
mkdir /u01
################################################################
# Install Java 8
apt install openjdk-8-jdk unzip -y
################################################################
#Install nomad
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install nomad -y
nomad -autocomplete-install
################################################################
#Configure Nomad
cp /tmp/nomad.d/nomad.service /etc/systemd/system/
systemctl enable nomad
systemctl start nomad
################################################################
#check nomad rediness
until nc -z -v -w30 localhost 4646
do
  echo "Waiting for Nomad connection..."
  # wait for 5 seconds before check again
  sleep 5
done
################################################################
#Deploy spring job in nomad
nomad run /tmp/nomad.d/spring-fixed-port.nomad