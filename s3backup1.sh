#! /bin/bash

DATE=$(date +%H-%M-%S)
BACKUP=db-$DATE.sqlbackup
DB_HOST=$1
DB_PASSWORD=$2
DB_NAME=$3
AWS_SECRET_KEY=$4
BUCKET_NAME=$5

mysqldump -u root -h $DB_HOST -p$DB_PASSWORD $DB_NAME > /tmp/$BACKUP && \
export AWS_ACCESS_KEY_ID=XXX
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY && \
echo "Uploading $BACKUP to s3 now" && \
aws s3 cp /tmp/db-$DATE.sqlbackup s3://$BUCKET_NAME/$BACKUP

