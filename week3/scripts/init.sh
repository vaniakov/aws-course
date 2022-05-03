set -x
REGION=us-east-1
BUCKET_NAME=ikova-aws-course-db

aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION
aws s3 cp ./dynamodb-script.sh s3://$BUCKET_NAME/
aws s3 cp ./rds-script.sql s3://$BUCKET_NAME/

set +x
