#!/bin/bash -eux

stateJson="$(cat)"
certificateId=$(jq -r '.certificate_id' <<< "${stateJson}")
awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

$awsCmd iot update-ca-certificate --certificate-id ${certificateId} --new-status ${active}
$awsCmd iot update-ca-certificate --certificate-id ${certificateId} --new-auto-registration-status ${allow_autoregistration}

carootPem="$(jq -r '.carootPem' <<< "${stateJson}")"
cacertSrl="$(jq -r '.cacertSrl' <<< "${stateJson}")"
cat <(jq ".certificateDescription | {
  certificate_id: .certificateId,
  certificate_arn: .certificateArn,
  certificate_pem: .certificatePem,
  status: .status,
  auto_registration_status: .autoRegistrationStatus,
  certificate_srl: \"${cacertSrl}\",
  caroot_pem: \"${carootPem}\"
}" <($awsCmd iot describe-ca-certificate --certificate-id ${certificateId}))
