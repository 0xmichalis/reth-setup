#!/bin/sh

podman network create ethnetwork || true

podman run --rm -v $(pwd)/podman-compose:/app/jwttoken localhost/jwt-generator:latest

podman-compose -f podman-compose/podman-compose.yml up -d
