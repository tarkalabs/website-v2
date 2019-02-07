#!/bin/sh

set -e

DATESTAMP=`date '+%d-%b-%Y-%H-%M-%S'`
TARFILE_NAME=tarka-build-$DATESTAMP.tar.gz
DEPLOY_DIR=tarkalabs-site-$DATESTAMP

echo "Building tarkalabs site"
echo "-----------------------"
bundle exec middleman build
tar zcfv /tmp/$TARFILE_NAME build/

echo "Transferring files to server"
echo "----------------------------"

ssh deploy@tarkalabs.com /bin/bash << EOF
  cd /home/deploy/sites
  mkdir $DEPLOY_DIR
EOF

scp /tmp/$TARFILE_NAME deploy@tarkalabs.com:/home/deploy/sites/$DEPLOY_DIR

ssh deploy@tarkalabs.com /bin/bash << EOF
  cd /home/deploy/sites/$DEPLOY_DIR
  tar xfv $TARFILE_NAME --strip 1
  rm $TARFILE_NAME
  cd ..
  rm tarkalabs
  ln -s $DEPLOY_DIR tarkalabs
EOF

echo "----------"
echo "SUCCESS!!!"
