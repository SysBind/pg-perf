#!/bin/bash

set -e

set_hostname()
{
    hostnamectl set-hostname alloy
    sed -i 's/bullseye/alloy/g' /etc/hosts
}

install_docker()
{
    apt update
    apt install -y ca-certificates curl gnupg lsb-release curl gpg
    mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_gsutil()
{
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-440.0.0-linux-x86_64.tar.gz
    tar xvf google-cloud-cli-440.0.0-linux-x86_64.tar.gz
    ./google-cloud-sdk/install.sh
}

set_hostname
install_docker
install_gsutil

GSUTIL=/home/vagrant/google-cloud-sdk/bin/gsutil

$GSUTIL cp -r gs://alloydb-omni-install/`$GSUTIL cat gs://alloydb-omni-install/latest` .

cd `$GSUTIL cat gs://alloydb-omni-install/latest`
tar -xzf alloydb_omni_installer.tar.gz && cd installer
bash install_alloydb.sh
mkdir /root/alloydb-data
sed -i "s|^\(DATADIR_PATH=\).*|\1/root/alloydb-data|" /var/alloydb/config/dataplane.conf
echo "host    all             all             192.168.0.0/16        trust"  >> /var/alloydb/config/pg_hba.conf
systemctl start alloydb-dataplane

echo -n "Machine IP <ALLOY>: "
ip add | grep "192.168"
