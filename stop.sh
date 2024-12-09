#!/bin/sh

systemctl --user stop container-rootless-cni-infra
systemctl --user stop container-lighthouse
systemctl --user stop container-reth
