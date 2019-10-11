#!/bin/bash -eux

awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

[[ -z "${parent_group_name}" ]] && parentGroupNameCmdOption='' || parentGroupNameCmdOption="--parent-group-name ${parent_group_name}"

cat <(jq "
    {
      arn: .thingGroupArn,
      id: .thingGroupId,
      name: .thingGroupName
    }
  " <(${awsCmd} iot create-thing-group --thing-group-name ${name} ${parentGroupNameCmdOption})
)
