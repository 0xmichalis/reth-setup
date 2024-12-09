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


mkdir -p ~/.config/systemd/user
cp container-* ~/.config/systemd/user/

systemctl --user daemon-reload

systemctl --user enable container-rootless-cni-infra
systemctl --user enable container-lighthouse
systemctl --user enable container-reth

systemctl --user restart container-rootless-cni-infra
systemctl --user restart container-lighthouse
systemctl --user restart container-reth

# echo 'Starting Prometheus...'
# podman run \
#     -v ./prometheus/:/etc/prometheus/ \
#     -v prometheusdata:/prometheus \
#     -p 9090:9090 \
#     -name prometheus \
#     prom/prometheus \
#     --config.file=/etc/prometheus/prometheus.yml \
#     --storage.tsdb.path=/prometheus

# echo 'Starting Grafana...'
# podman run \
#     -p 3000:3000 \
#     -e PROMETHEUS_URL=http://prometheus:9090 \
#     -v grafanadata:/var/lib/grafana \
#     -v ./grafana/datasources:/etc/grafana/provisioning/datasources \
#     -v ./grafana/dashboards:/etc/grafana/provisioning_temp/dashboards \
