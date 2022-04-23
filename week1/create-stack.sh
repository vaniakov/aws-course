STACK_NAME=ASG
KEY_NAME=lohikaMBP-west

echo "Creating stack: $STACK_NAME"
STACK_ID=$(aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://AutoScalingMultiAZ.template.json --parameters ParameterKey=KeyName,ParameterValue=$KEY_NAME ParameterKey=InstanceType,ParameterValue=t2.micro | jq -r .StackId)

echo "Wating for Stack ID: $STACK_ID to complete."
aws cloudformation wait stack-create-complete --stack-name $STACK_ID
aws ec2 describe-instances | jq ".Reservations[].Instances[0].PublicIpAddress"

