#!/bin/sh

set -x
REGION=us-east-1
BUCKET_NAME=ikova-aws-course-3
FILE_NAME=small.txt

echo "AWS course: S3" > $FILE_NAME

aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
aws s3 cp ./$FILE_NAME s3://$BUCKET_NAME/
curl https://$BUCKET_NAME.s3.amazonaws.com/$FILE_NAME

set +x
