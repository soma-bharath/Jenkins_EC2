#!/bin/bash

# Variables
S3_BUCKET="my-jenkins-backup-bucket"
BACKUP_PATH="/apps"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="jenkins-backup-$TIMESTAMP.tar.gz"

# Create a tar.gz of the Jenkins data
tar -czvf /tmp/$BACKUP_FILE -C $BACKUP_PATH .

# Copy the backup file to S3
aws s3 cp /tmp/$BACKUP_FILE s3://$S3_BUCKET/

# Remove the local backup file
rm /tmp/$BACKUP_FILE
