#!/bin/bash -eux

stateJson="$(cat)"
certificateId=$(jq -r '.id' <<< "${stateJson}")
awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

$awsCmd iot update-certificate --certificate-id ${certificateId} --new-status ${status}

certKey="$(jq -r '.key' <<< "${stateJson}")"

cat <(jq ".certificateDescription |
    {
      arn: .certificateArn,
      id: .certificateId,
      ca_certificate_id: .caCertificateId,
      status: .status,
      pem: .certificatePem,
      key: \"${certKey}\"
    }
  " <(${awsCmd} iot describe-certificate --certificate-id ${certificateId})
)
