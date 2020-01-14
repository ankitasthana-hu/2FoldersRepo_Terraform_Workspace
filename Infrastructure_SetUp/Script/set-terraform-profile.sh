#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "ERROR!!!"
  echo "Script must be 'sourced' in order to set the ENV VARs correctly"
  echo "Usage:"
  echo "$ source `basename $0` [aws_profile]"
  exit 1
fi

profile="$1"
creds_file="${HOME}/.aws/credentials"
region="us-east-1"
echo ""
if [ "$profile" == "" ]; then
  echo "WARNING..."
  echo "No profile value specified, defaulting to 'default'"
  profile="default"
fi
if ! grep -q "\[$profile\]" "$creds_file"
then
  echo "ERROR!!"
  echo "Sorry Charlie, no profile named '${profile}' found in aws credentials file: ${creds_file}"
  return 1
fi

export TF_VAR_aws_profile="$profile"
export AWS_PROFILE="$profile"
export AWS_SHARED_CREDENTIALS_FILE="${creds_file}"
export AWS_DEFAULT_REGION="${region}"

echo "Exported the following variables:"
echo "TF_VAR_aws_profile          = ${TF_VAR_aws_profile}"
echo "AWS_PROFILE                 = ${AWS_PROFILE}"
echo "AWS_SHARED_CREDENTIALS_FILE = ${AWS_SHARED_CREDENTIALS_FILE}"
echo "AWS_DEFAULT_REGION          = ${AWS_DEFAULT_REGION}"
