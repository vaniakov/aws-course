BUCKET_NAME=ikova-aws-course-3

aws s3api delete-objects \
    --bucket ${BUCKET_NAME} \
    --delete "$(aws s3api list-object-versions \
    --bucket "${BUCKET_NAME}" \
    --output=json \
    --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

aws s3api delete-bucket --bucket=$BUCKET_NAME
