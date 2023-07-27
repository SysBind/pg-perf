#!/bin/bash

set -e

vagrant up

POSTGRES_IP=`vagrant ssh postgres -c "ip addr" | grep "192.168" | cut -d'/' -f1 | cut -d't' -f2 |  tr -d " "`
ALLOY_IP=`vagrant ssh alloy -c "ip addr" | grep "192.168" | cut -d'/' -f1 | cut -d't' -f2 |  tr -d " "`

echo "Postgres at $POSTGRES_IP"
echo "Alloy at $ALLOY_IP"

[ -d moodle ] || git clone https://github.com/moodle/moodle.git -b MOODLE_402_STABLE

pushd moodle

mkdir -p tmp

#... run tests
psql --host $POSTGRES_IP --user postgres -c "CREATE DATABASE moodle"
sed "s/__DB_HOST__/$POSTGRES_IP/g" ../config.php > config.php
time php74 admin/cli/install_database.php --agree-license --adminpass='q1w2e3r4'

read x
psql --host $ALLOY_IP --user postgres -c "CREATE DATABASE moodle"
sed "s/__DB_HOST__/$ALLOY_IP/g" ../config.php > config.php
time php74 admin/cli/install_database.php --agree-license --adminpass='q1w2e3r4'

popd
