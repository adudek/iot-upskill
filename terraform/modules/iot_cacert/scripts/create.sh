#!/bin/bash -eux

awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

carootPem="${caroot_pem}"
carootKey="${caroot_key}"
if [[ -z "${caroot_pem}" || -z "${caroot_key}" ]]; then
  temp="$(mktemp)"
  # create root ca certificate signing key
  openssl genrsa -out "${temp}.key" 2048
  # create root ca certificate
  openssl req -new -sha256 -key "${temp}.key" -nodes -out "${temp}.csr" -config 'scripts/ca-cert.conf' -subj "${certificate_information}"
  openssl x509 -req -days 3650 -extfile 'scripts/ca-cert.conf' -extensions v3_ca -in "${temp}.csr" -signkey "${temp}.key" -out "${temp}.pem"

  carootPem="$(cat ${temp}.pem)"
  carootKey="$(cat ${temp}.key)"
  rm -f "${temp}" "${temp}.pem" "${temp}.key" "${temp}.csr"
fi

#TODO: validate cacert against caroot using openssl
if [[ -z "${caroot_pem}" || -z "${caroot_key}" || -z "${cacert_pem}" || -z "${cacert_key}" ]]; then
  temp="$(mktemp)"
  ## create ca certificate
  registrationCode="$(jq -r .registrationCode < <($awsCmd iot get-registration-code))"
  [[ -n "${registrationCode}" ]]
  openssl genrsa -out "${temp}.key" 2048
  # generate csr 
  openssl req -new -key "${temp}.key" -out "${temp}.csr" -config 'scripts/ca-cert.conf' -subj "${certificate_information}/CN=${registrationCode}"
  # create ca certificate for aws
  openssl x509 -req -extfile 'scripts/ca-cert.conf' -extensions v3_ca -in "${temp}.csr" -CA <(echo "${carootPem}") -CAkey <(echo "${carootKey}") -CAcreateserial -out "${temp}.pem" -days 500 -sha256 -CAserial "${temp}.srl"

  cacertPem="$(cat ${temp}.pem)"
  cacertKey="$(cat ${temp}.key)"
  cacertSrl="$(cat ${temp}.srl)"
  rm -f "${temp}" "${temp}.pem" "${temp}.key" "${temp}.csr" "${temp}.srl"
fi

declare -A flags=(
  ['ENABLE']='--allow-auto-registration'
  ['DISABLE']='--no-allow-auto-registration'
  ['ACTIVE']='--set-as-active'
  ['INACTIVE']='--no-set-as-active'
)

certificateId="$(jq -r '.certificateId' <(
  ${awsCmd} iot register-ca-certificate --ca-certificate "${carootPem}" --verification-certificate "${cacertPem}" ${flags[${allow_autoregistration}]} ${flags[${active}]}
))"

cat <(jq ".certificateDescription | {
    certificate_id: .certificateId,
    certificate_arn: .certificateArn,
    certificate_key: \"${cacertKey}\",
    certificate_pem: .certificatePem,
    status: .status,
    auto_registration_status: .autoRegistrationStatus,
    certificate_srl: \"${cacertSrl}\",
    caroot_key: \"${carootKey}\",
    caroot_pem: \"${carootPem}\"
  }" <(${awsCmd} iot describe-ca-certificate --certificate-id ${certificateId})
)
