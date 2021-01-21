#!/bin/bash

DOWNLOAD_BIANARIES="true"
INSTALL_BIANARIES="true"
NOMAD_VERSION=0.12.7
NOMAD_CONFIGS="../nomad.d"
CONSUL_VERSION=1.8.5
##Download nomad & consul bianries
if [ "${DOWNLOAD_BIANARIES}" = "true" ]; then
wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
fi
################################################################
if [ "${INSTALL_BIANARIES}" = "true" ]; then
##Install nomad
unzip nomad_${NOMAD_VERSION}_linux_amd64.zip
chmod +x nomad
mv nomad /usr/bin
mkdir -p /etc/nomad.d
mkdir /opt/nomad
################################################################
##Install consul
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
chmod +x consul
mv consul /usr/bin
################################################################
##Configure nomad & consul
cp ${NOMAD_CONFIGS}/*.service /etc/systemd/system/
cp ${NOMAD_CONFIGS}/nomad.hcl /etc/nomad.d/
systemctl enable nomad consul
systemctl start consul nomad
################################################################
fi