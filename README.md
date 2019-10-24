# iot-upskill
Example code developed for PGS Software.
Licenced under LGPLv2

## Prepare AWS iot infrastructure
```
brew|rpm|apt|apk install jq
cd terraform
platform="darwin_amd64|linux_amd64"
release="terraform-provider-shell_v0.1.2"
mkdir -p .terraform/plugins/${platform}
curl -L "https://github.com/scottwinkler/${release/_//releases/download/}/${release}.${platform}" -o ".terraform/plugins/${platform}/${release}"
terraform init
terraform apply
```

## Run node.js iot sdk program
cd nodejs
npm install
node echo.js
node shadow.js
