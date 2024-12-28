#!/bin/bash

# Borrowed from EthStaker's prepare for the merge guide
# See https://github.com/remyroy/ethstaker/blob/main/prepare-for-the-merge.md#configuring-a-jwt-token-file

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
JWT_DIR=${SCRIPT_DIR}/jwttoken
JWT_FILE=${JWT_DIR}/jwt.hex

# Create the JWT token directory if it doesn't exist
mkdir -p ${JWT_DIR}

# Generate a JWT token file if it doesn't exist
if [[ ! -f ${JWT_FILE} ]]; then
  openssl rand -hex 32 | tr -d "\n" | tee ${JWT_FILE}
  echo "JWT token created at ${JWT_FILE}"
else
  echo "${JWT_FILE} already exists."
fi
