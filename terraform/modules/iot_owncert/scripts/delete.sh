#!/bin/bash -eux

stateJson="$(cat)"
certificateId=$(jq -r '.certificate_id' <<< "${stateJson}")
awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

${awsCmd} iot update-certificate --certificate-id ${certificateId} --new-status INACTIVE
${awsCmd} iot delete-certificate --certificate-id ${certificateId}
