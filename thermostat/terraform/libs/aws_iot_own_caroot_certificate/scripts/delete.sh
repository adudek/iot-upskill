#!/bin/bash -eux

stateJson="$(cat)"
certificateId=$(jq -r '.id' <<< "${stateJson}")
awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

${awsCmd} iot update-ca-certificate --certificate-id ${certificateId} --new-status INACTIVE
${awsCmd} iot delete-ca-certificate --certificate-id ${certificateId}
