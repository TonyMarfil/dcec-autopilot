#!/bin/bash
  
TEMPLATES_DIRECTORY=/home/ubuntu/

export TF_VAR_resourceOwner="student1"
export TF_VAR_awsRegion="us-west-2"
export TF_VAR_awsAz1="us-west-2a"
export TF_VAR_awsAz2="us-west-2b"

if test -f ~/udf_user.pub; then
  export TF_VAR_sshPublicKey=$(<~/udf_user.pub)
  # printf "SSH key found:\n%s\n\n" "${TF_VAR_sshPublicKey}"
else
  printf "SSH key not found. This script looks for udf_user.pub in the home directory.\n\n" >&2
fi

curl -s 10.1.1.254/cloudAccounts > cloudAccounts.json

export AWS_ACCESS_KEY_ID=$(jq -r '.cloudAccounts[].apiKey' < ./cloudAccounts.json)
export AWS_SECRET_ACCESS_KEY=$(jq -r '.cloudAccounts[].apiSecret' < ./cloudAccounts.json)

export TF_VAR_AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export TF_VAR_AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export TF_VAR_AWS_ACCOUNT_ID=$(jq -r '.cloudAccounts[].accountId' < ./cloudAccounts.json)
export TF_VAR_AWS_CONSOLE_LINK=$(printf "https://%s.signin.aws.amazon.com/console" ${TF_VAR_AWS_ACCOUNT_ID})
export TF_VAR_AWS_USER=$( jq -r '.cloudAccounts[].consoleUsername' < ./cloudAccounts.json)
export TF_VAR_AWS_PASSWORD="$(jq -r '.cloudAccounts[].consolePassword' < ./cloudAccounts.json)"

if test -f ~/.aws/config; then
  cat ~/.aws/config
elif test -f ~/.aws/credentials; then
  cat ~/.aws/credentials
else
  mkdir ~/.aws
  envsubst < /home/ubuntu/config.template > ~/.aws/config
  cat ~/.aws/config
fi

printf "AWS Console URL:\n%s\n\n" ${TF_VAR_AWS_CONSOLE_LINK}
printf "AWS Console Username:\n%s\n\n" ${TF_VAR_AWS_USER}
printf "AWS Console Password:\n%s\n\n" ${TF_VAR_AWS_PASSWORD}

#Not used in this lab, but might be useful in the future.
envsubst < $TEMPLATES_DIRECTORY/aws-console.template > ./"Amazon Web Services Sign-In.url"

printf "Global environment variables starting with TF_VAR_ are available to use as Terraform variables.\nEnvironment variables will be checked last for a value.\nEnvironment variables can be overriden in a .tfvars file or using terraform apply -v 'key-value'\n\n"

env | grep TF_VAR

if [ $? -eq 0 ]
then
  echo "The script ran ok"
else
  echo "The script failed" >&2
fi
