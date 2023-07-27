#!/bin/bash

set -e

set_hostname()
{
    hostnamectl set-hostname alloy
    sed -i 's/bullseye/postgres/g' /etc/hosts
}

set_hostname

apt update

apt install -y wget lsb-release gnupg2


# Create the file repository configuration:
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Update the package lists:
apt update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
apt -y install postgresql-14

echo "listen_addresses = '0.0.0.0'" >> /etc/postgresql/14/main/postgresql.conf
echo "host    all             all             192.168.0.0/16        trust"  >>  /etc/postgresql/14/main/pg_hba.conf
systemctl restart postgresql

echo -n "Machine IP <POSTGRES>: "
ip add | grep "192.168"
