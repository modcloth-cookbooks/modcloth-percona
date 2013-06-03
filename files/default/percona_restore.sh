#!/bin/bash

# Define path to binaries used by this script
PATH="/mysql/bin:/mysql/libexec:/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin"

# Capture backup source via command line argument
SOURCE=$1

# Error out if no backup source is defined via command line
if [ "${SOURCE}" = "" ]; then
  echo "Please enter a valid source! Example: /net/filer.demo.modcloth.com/export/Modcloth/shared02/backups/percona/backup-db-ecomm.prod.modcloth.com/201211290800.gz"
  exit 1
fi

# Check for lock file
if [ -f /tmp/db-restore_lock ]; then
  exit 0
fi

# Creating lock file
touch /tmp/db-restore_lock

# Function to disable the Percona service
function disable_percona {
  echo "-- Disabling Percona service" `date`
  svcadm disable percona-server
  PERCONA_STATE=`svcs -a | grep percona-server | cut -d" " -f 1`
  while [ "${PERCONA_STATE}" != "disabled" ]; do 
    echo -n "."
    sleep 1
    PERCONA_STATE=`svcs -a | grep percona-server | cut -d" " -f 1`
  done
  echo "done"
}

# Function to enable the Percona service
function enable_percona {
  echo "-- Enabling the Percona service" `date`
  svcadm enable percona-server
  PERCONA_STATE=`svcs -a | grep percona-server | cut -d" " -f 1`
  while [ "${PERCONA_STATE}" != "online" ]; do 
    echo -n "."
    sleep 1
    PERCONA_STATE=`svcs -a | grep percona-server | cut -d" " -f 1`
  done
  echo "done"
}

# Function to remove existing database files
function remove_old_db {
  echo "-- Removing existing database files" `date`
  cd /databases
  rm -rf *
}

# Function to extract backup source, important thing to note is the -i switch on the tar command... it is used to ignore zeros put there during the stream process during the backup
function extract_new_db {
  echo "-- Extracting Db backup" `date`
  cd /databases
  tar -xzif ${SOURCE}
}

# Function to use innobackup to prepare extracted backup, applying any logged changes that may have happened during the backup process.  This function also updates the permissions of the database files to mysql:mysql.
function prepare_new_db {
  echo "-- Preparing Db backup" `date`
  /opt/local/bin/innobackupex --apply-log --use-memory=2G --ibbackup=/opt/local/bin/xtrabackup /databases > /dev/null 2>&1
  echo "-- Changing permissions" `date`
  chown -R mysql:mysql /var/mysql
}

# Run each of the functions in the proper order: disable, remove, extract, prepare, enable
disable_percona
remove_old_db
extract_new_db
prepare_new_db
enable_percona

# Removing lock file
rm /tmp/db-restore_lock
