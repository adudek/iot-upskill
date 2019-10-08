#!/bin/bash -eux

stateJson="$(cat)"
certificateId=$(jq -r '.certificate_id' <<< "${stateJson}")
awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

$awsCmd iot update-certificate --certificate-id ${certificateId} --new-status ${status}

certKey="$(jq -r '.certificate_key' <<< "${stateJson}")"
certSrl="$(jq -r '.certificate_srl' <<< "${stateJson}")"

cat <(jq ".certificateDescription | {
    certificate_arn: .certificateArn,
    certificate_id: .certificateId,
    ca_certificate_id: .caCertificateId,
    status: .status,
    certificate_pem: .certificatePem,
    certificate_key: \"${certKey}\",
    certificate_srl: \"${certSrl}\",
  }" <(${awsCmd} iot describe-certificate --certificate-id ${certificateId})
)
