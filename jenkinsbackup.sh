#!/bin/bash

S3_BUCKET="my-jenkins-backup-bucket"
BACKUP_PATH="/apps"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="jenkins-backup-$TIMESTAMP.tar.gz"

echo "Creating a tar.gz of the Jenkins data"
sudo tar -czvf /tmp/$BACKUP_FILE -C $BACKUP_PATH .

echo "Copying the backup file to S3"
sudo aws s3 cp /tmp/$BACKUP_FILE s3://$S3_BUCKET/

echo "Removing the local backup file"
sudo rm /tmp/$BACKUP_FILE
