#!/bin/bash -eux

stateJson="$(cat)"
thingGroupName=$(jq -r '.name' <<< "${stateJson}")
awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

${awsCmd} iot delete-thing-group --thing-group-name ${thingGroupName}
