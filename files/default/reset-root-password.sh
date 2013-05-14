#!/bin/bash
# An abomination of a shell script that blanks the root password on new Percona
# installations... doesn't run if /root/.my.cnf file exists

if [ -e /root/.my.cnf ] ; then
  echo "NO, HUMAN." >&2
  exit 86
fi

echo "-- Killing existing Percona process"
kill `ps aux | grep /opt/local/sbin/mysqld | awk '{print $2}'`

echo "-- Disabling Percona"
svcadm disable -s percona-server

echo "-- Starting Percona without grant tables"
/opt/local/sbin/mysqld --skip-grant-tables --user=mysql --basedir=/opt/local --datadir=/var/mysql &
sleep 10

echo "-- Resetting password"
echo "UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

echo "-- Stopping Percona without grant tables"
PID=`ps -ef | grep skip-grant-tables | grep -v grep | awk '{print $2}'`
while [  "$PID" != "" ];do
  kill $PID
  PID=`ps -ef | grep skip-grant-tables | grep -v grep | awk '{print $2}'`
  sleep 1
done

echo "-- Enabling Percona"
svcadm enable -s percona-server

echo "-- Creating /root/.my.cnf file"
touch /root/.my.cnf
chmod 600 /root/.my.cnf
echo "[client]" >> /root/.my.cnf
echo "user=root" >> /root/.my.cnf
