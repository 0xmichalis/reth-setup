#!/bin/sh

podman-compose -f podman-compose/podman-compose.yml down

podman system prune -f
