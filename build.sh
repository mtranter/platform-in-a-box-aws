#! /usr/bin/env bash

set -euo pipefail

for d in modules/*/ ; do
    terraform fmt -recursive
    pushd "$d"
    terraform init
    terraform validate
    tfsec
    terraform-docs markdown ./ > README.md
    popd
done