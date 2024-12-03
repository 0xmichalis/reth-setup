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

# Create the podman network if it doesn't exist
NETWORK_NAME="ethnetwork"
if podman network ls | grep ${NETWORK_NAME}; then
  echo "Creating ${NETWORK_NAME} network..."
  podman network create ${NETWORK_NAME}
else
  echo "Network ${NETWORK_NAME} already exists."
fi

# Start the Reth container if it's not already running
CONTAINER_NAME_RETH="reth"
if ! podman ps --filter "name=${CONTAINER_NAME_RETH}" --filter "status=running" | grep ${CONTAINER_NAME_RETH} > /dev/null 2>&1; then
  echo "Starting ${CONTAINER_NAME_RETH}..."
  podman rm -f ${CONTAINER_NAME_RETH} > /dev/null 2>&1
  podman run \
      -v rethdata:/root/.local/share/reth/mainnet \
      -v rethlogs:/root/logs \
      -v ${JWT_DIR}:/root/jwt:ro \
      -p 9011:9011 \
      -p 30303:30303 \
      -p 30303:30303/udp \
      -p 8545:8545 \
      -p 8551:8551 \
      --pid=host \
      --name ${CONTAINER_NAME_RETH} \
      --network ${NETWORK_NAME} \
      -d \
      ghcr.io/paradigmxyz/reth \
      node \
      --full \
      --chain=mainnet \
      --metrics 0.0.0.0:9011 \
      --log.file.directory /root/logs \
      --authrpc.addr 0.0.0.0 \
      --authrpc.port 8551 \
      --authrpc.jwtsecret /root/jwt/jwt.hex \
      --http --http.addr 0.0.0.0 --http.port 8545 \
      --http.api "eth,net,web3"
else
  echo "Container ${CONTAINER_NAME_RETH} is already running."
fi

# Start the Lighthouse container if it's not already running
CONTAINER_NAME_LIGHTHOUSE="lighthouse"
if ! podman ps --filter "name=${CONTAINER_NAME_LIGHTHOUSE}" --filter "status=running" | grep ${CONTAINER_NAME_LIGHTHOUSE} > /dev/null 2>&1; then
  echo "Starting ${CONTAINER_NAME_LIGHTHOUSE}..."
  podman rm -f ${CONTAINER_NAME_LIGHTHOUSE} > /dev/null 2>&1
  podman run \
      -v lighthousedata:/root/.lighthouse \
      -v ${JWT_DIR}:/root/jwt:ro \
      -p 5052:5052/tcp \
      -p 5053:5053/tcp \
      -p 5054:5054/tcp \
      -p 9000:9000/tcp \
      -p 9000:9000/udp \
      -p 9001:9001/udp \
      --name ${CONTAINER_NAME_LIGHTHOUSE} \
      --network ${NETWORK_NAME} \
      -d \
      sigp/lighthouse:v6.0.0 \
      lighthouse bn \
      --network mainnet \
      --http --http-address 0.0.0.0 \
      --execution-endpoint http://reth:8551 \
      --metrics --metrics-address 0.0.0.0 \
      --execution-jwt /root/jwt/jwt.hex \
      --log-color \
      --checkpoint-sync-url https://mainnet.checkpoint.sigp.io
else
  echo "Container ${CONTAINER_NAME_LIGHTHOUSE} is already running."
fi


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

