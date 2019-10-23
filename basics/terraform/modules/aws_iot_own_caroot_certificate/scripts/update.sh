#!/bin/bash -eux

stateJson="$(cat)"
certificateId=$(jq -r '.id' <<< "${stateJson}")
awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

$awsCmd iot update-ca-certificate --certificate-id ${certificateId} --new-status ${active}
$awsCmd iot update-ca-certificate --certificate-id ${certificateId} --new-auto-registration-status ${allow_autoregistration}

carootKey="$(jq -r '.key' <<< "${stateJson}")"

cat <(jq ".certificateDescription |
    {
      id: .certificateId,
      arn: .certificateArn,
      key: \"${carootKey}\",
      pem: .certificatePem,
      status: .status,
      auto_registration_status: .autoRegistrationStatus
    }
  " <(${awsCmd} iot describe-ca-certificate --certificate-id ${certificateId})
)
