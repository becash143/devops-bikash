#!/bin/bash
set -e

# update os packages
apt-get update
apt-get upgrade -y
mkdir /u01
################################################################
# Install Java 8
apt install openjdk-8-jdk unzip -y
################################################################
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
################################################################
# Install Oracle DB
docker login -u psdeveloper -p FBvAgfFHV8k8eHUh
docker run -d -p 1521:1521 --restart=always --name oracle progressoft/oracle:db-12c-ee
################################################################
#Waiting for database to be ready and up
echo "Waiting for database to be ready and up"
    echo "To check the progress 'docker logs -f oracle'"
    while [ "$db_ready" = "" ]; do
        export db_ready=$(docker logs oracle 2>&1 | grep -o "Database ready to use");
        x=$((x+1));echo -ne "\r${BAR:0:$x}";
            sleep 3;
    done
################################################################
# Install artemis DB
docker run -d --restart=always  --name=artemis -e DISABLE_SECURITY=true -e ARTEMIS_USERNAME=artemis  -e ARTEMIS_PASSWORD=artemis  -p 8161:8161 -p 61616:61616  vromero/activemq-artemis
################################################################
#Download Mpay DBdump
curl -OL http://nyc3.digitaloceanspaces.com/psmarsel/mpay.zip
unzip mpay.zip -d /u01
################################################################
#create mpay DB
docker cp /u01/mpay/Create_mPay_tablespaces.sql oracle:/tmp
docker cp /u01/mpay/Create_mPay_User.sql oracle:/tmp
docker cp /u01/mpay/khal.dmp oracle:/tmp
docker exec -it oracle sqlplus sys/oracle as sysdba @/tmp/Create_mPay_tablespaces.sql
docker exec -it oracle sqlplus sys/oracle as sysdba @/tmp/Create_mPay_User.sql
docker exec -it oracle imp system/oracle file=/tmp/khal.dmp fromuser=mpay touser=mpay ignore=y
################################################################
#Install nomad
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install nomad consul -y
nomad -autocomplete-install
################################################################
#Configure Nomad & consul
cp /tmp/nomad.d/*.service /etc/systemd/system/
cp /tmp/nomad.d/nomad.hcl /etc/nomad.d/
systemctl enable nomad consul
systemctl start consul nomad
################################################################
#check nomad & consul rediness
until nc -z -v -w30 localhost 8500 4646 4647 4648
do
  echo "Waiting for Nomad connection..."
  # wait for 5 seconds before check again
  sleep 5
done
################################################################
#Deploy spring job in nomad
sleep 10
nomad node status
for i in $(ls /tmp/nomad.d/*.nomad); do
 nomad run ${i}
done
nomad status
