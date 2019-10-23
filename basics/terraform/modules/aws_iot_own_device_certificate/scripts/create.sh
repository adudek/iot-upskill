#!/bin/bash -eux

awsCmd="aws --profile ${aws_profile} --region ${aws_region}"

temp="$(mktemp)"
# create signing key
openssl genrsa -out "${temp}.key" 2048
# create certificate
openssl req -new -key "${temp}.key" -out "${temp}.csr" -subj "${certificate_information}"
openssl x509 -req -in "${temp}.csr" -CA <(echo "${caroot_pem}") -CAkey <(echo "${caroot_key}") -CAcreateserial -out "${temp}.pem" -days 500 -sha256 -CAserial "${temp}.srl"

certPem="$(cat ${temp}.pem)"
certKey="$(cat ${temp}.key)"
certSrl="$(cat ${temp}.srl)"

rm -f "${temp}" "${temp}.pem" "${temp}.key" "${temp}.srl" "${temp}.csr"

certificateId="$(jq -r '.certificateId' <(
  ${awsCmd} iot register-certificate --certificate-pem "${certPem}" --ca-certificate-pem "${caroot_pem}" --status ${status}
))"

cat <(jq ".certificateDescription |
    {
      arn: .certificateArn,
      id: .certificateId,
      ca_certificate_id: .caCertificateId,
      status: .status,
      pem: .certificatePem,
      key: \"${certKey}\"
    }
  " <(${awsCmd} iot describe-certificate --certificate-id ${certificateId})
)
