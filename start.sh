#!/bin/sh

# Build the image first with `docker build -t jwt-generator ./jwt`
docker run --rm -v jwt-volume:/app/jwttoken jwt-generator

mkdir -p ~/.config/systemd/user
cp container-* ~/.config/systemd/user/

systemctl --user daemon-reload

systemctl --user enable container-rootless-cni-infra
systemctl --user enable container-lighthouse
systemctl --user enable container-reth

systemctl --user start container-rootless-cni-infra
systemctl --user start container-lighthouse
systemctl --user start container-reth

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
