#!/bin/bash -eux

awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

#TODO detect arn instead of name
[[ -z "${thing_group_name}" ]] && thingGroupNameCmdOption='' || thingGroupNameCmdOption="--thing-group-name ${thing_group_name}"
[[ -z "${thing_name}" ]] && thingNameCmdOption='' || thingNameCmdOption="--thing-name ${thing_name}"
${awsCmd} iot add-thing-to-thing-group ${thingGroupNameCmdOption} ${thingNameCmdOption}
