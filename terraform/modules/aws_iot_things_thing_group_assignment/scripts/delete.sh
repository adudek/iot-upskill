#!/bin/bash -eux

awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

#TODO detect arn instead of name
[[ -z "${thing_group_name}" ]] && thingGroupNameCmdOption='' || thingGroupNameCmdOption="--thing-group-name ${thing_group_name}"
[[ -z "${thing_name}" ]] && thingNameCmdOption='' || thingNameCmdOption="--thing-name ${thing_name}"
# Accepting exitcode 255:
# An error occurred (ResourceNotFoundException) when calling the RemoveThingFromThingGroup operation: Thing not found.
${awsCmd} iot remove-thing-from-thing-group ${thingGroupNameCmdOption} ${thingNameCmdOption} || [[ $? -eq 255 ]]
