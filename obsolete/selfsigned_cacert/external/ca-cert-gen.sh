#!/bin/bash -eux

read json || [[ -n "${json}" ]]
cacertPem="$(jq -r        '.cacertPem' <<< "${json}")"
cacertKey="$(jq -r        '.cacertKey' <<< "${json}")"
conf="$(jq -r             '.cacertConf' <<< "${json}")"
create="$(jq -r           '.createCerts' <<< "${json}")"
carootKey="$(jq -r        '.carootKey' <<< "${json}")"
carootPem="$(jq -r        '.carootPem' <<< "${json}")"
awsProfile="$(jq -r       '.awsProfile' <<< "${json}")"
awsRegion="$(jq -r        '.awsRegion' <<< "${json}")"
active="$(jq -r           '.active' <<< "${json}")"
autoregistration="$(jq -r '.autoregistration' <<< "${json}")"
certificateSubj="$(jq -r  '.certificate_information' <<< "${json}")"

awsCmd="aws --profile ${awsProfile} --region ${awsRegion}"

if ! [[ -f "${carootPem}" && -f "${carootKey}" ]]; then
  [[ "${create}" == 'create' ]] || { echo "ERROR: ${carootPem} ${carootKey} pair not found!" >&2; exit 1; }
  temp="$(mktemp)"
  # create root ca certificate signing key
  openssl genrsa -out "${temp}.key" 2048
  # create root ca certificate
  openssl req -new -sha256 -key "${temp}.key" -nodes -out "${temp}.csr" -config "${conf}" -subj "${certificateSubj}"
  openssl x509 -req -days 3650 -extfile "${conf}" -extensions v3_ca -in "${temp}.csr" -signkey "${temp}.key" -out "${temp}.pem"

  mkdir -p "$(dirname "${carootPem}")"
  mv "${temp}.pem" "${carootPem}"
  mkdir -p "$(dirname "${carootKey}")"
  mv "${temp}.key" "${carootKey}"
  rm -rf "${temp}*"
fi

if ! [[ -f "${cacertPem}" && -f "${cacertKey}" ]]; then
  [[ "${create}" == 'create' ]] || { echo "ERROR: ${cacertPem} ${cacertKey} pair not found!" >&2; exit 1; }

  temp="$(mktemp)"

  ## create ca certificate  for device certificates 
  registrationCode="$(jq -r .registrationCode < <($awsCmd iot get-registration-code))"
  [[ -n "${registrationCode}" ]]
  openssl genrsa -out "${temp}.key" 2048
  # generate csr 
  openssl req -new -key "${temp}.key" -out "${temp}.csr" -config "${conf}" -subj "${certificateSubj}/CN=${registrationCode}"
  # create ca certificate for aws
  openssl x509 -req  -extfile "${conf}" -extensions v3_ca -in "${temp}.csr" -CA "${carootPem}" -CAkey "${carootKey}" -CAcreateserial -out "${temp}.pem" -days 500 -sha256

  mkdir -p "$(dirname "${cacertKey}")"
  mv "${temp}.key" "${cacertKey}"
  mkdir -p "$(dirname "${cacertPem}")"
  mv "${temp}.pem" "${cacertPem}"
  rm -rf "${temp}*"

fi

declare -A flags=(
  ['ENABLE']='--allow-auto-registration'
  ['DISABLE']='--no-allow-auto-registration'
  ['ACTIVE']='--set-as-active'
  ['INACTIVE']='--no-set-as-active'
)

# attempt to register CA certificate
set +e
cacertOut="$($awsCmd iot register-ca-certificate --ca-certificate "file://${carootPem}" --verification-certificate "file://${cacertPem}" ${flags[${autoregistration}]} ${flags[${active}]} 2>&1)"
exitCode=${?}
set -e

# AWS QUIRK: because AWS doesn't provide describe-ca-cert by pem filters, certificate id can be obtained by parsing error output of register-ca-certificate command
if [[ ${exitCode} -eq 255 ]]; then
  cacertId="${cacertOut#*ID:}"
  # enforce configuration settings on preexisting certificate
  $awsCmd iot update-ca-certificate --certificate-id "${cacertId}" --new-status "${active}"
  $awsCmd iot update-ca-certificate --certificate-id "${cacertId}" --new-auto-registration-status "${autoregistration}"
fi

if [[ ${exitCode} -eq 0 ]]; then
  cacertId="$(jq -r '.certificateId' <<< "${cacertOut}")"
fi

jq '.certificateDescription | {
  certificateId: .certificateId,
  certificateArn: .certificateArn,
  certificatePem: .certificatePem,
  status: .status,
  autoRegistrationStatus: .autoRegistrationStatus
}' <($awsCmd iot describe-ca-certificate --certificate-id "${cacertId}")

