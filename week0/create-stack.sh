STACK_NAME=EC2InstanceWithSecurityGroup
KEY_NAME=lohikaMBP-west

echo "Creating stack: $STACK_NAME"
STACK_ID=$(aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://EC2InstanceWithSecurityGroup.template.json --parameters ParameterKey=KeyName,ParameterValue=$KEY_NAME ParameterKey=InstanceType,ParameterValue=t2.micro | jq -r .StackId)

echo "Wating for Stack ID: $STACK_ID to complete."
OUTPUT=$(aws cloudformation wait stack-create-complete --stack-name $STACK_ID && aws cloudformation describe-stacks --stack-name $STACK_ID)
echo "Output: \n $OUTPUT | jq ."

IP=$(echo $OUTPUT | jq -r -c ".Stacks[0].Outputs | map(select(.OutputKey | contains (\"PublicIP\"))) | .[0].OutputValue")
echo "ssh -i $KEY_NAME.pem ec2-user@$IP"
