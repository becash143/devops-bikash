#!/bin/bash

# update os packages
apt-get update
apt-get upgrade -y
mkdir /u01
################################################################
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
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
#Install CNI plugins
mkdir -p /opt/cni/bin/
wget https://github.com/containernetworking/plugins/releases/download/v0.8.7/cni-plugins-linux-amd64-v0.8.7.tgz
tar -xzvf cni-plugins-linux-amd64-v0.8.7.tgz --directory /opt/cni/bin
################################################################
#Configure Nomad
cp /tmp/nomad.d/*.hcl /etc/nomad.d 
cp /tmp/nomad.d/*.service /etc/systemd/system/
systemctl enable nomad
systemctl enable nomad-worker1
systemctl enable nomad-worker2
systemctl start nomad
systemctl start nomad-worker1
systemctl start nomad-worker2
################################################################
#check nomad rediness
until nc -z -v -w30 localhost 4646 5656 5657
do
  echo "Waiting for Nomad connection..."
  # wait for 5 seconds before check again
  sleep 5
done
################################################################
#Deploy spring job in nomad
nomad run /tmp/nomad.d/spring.nomad