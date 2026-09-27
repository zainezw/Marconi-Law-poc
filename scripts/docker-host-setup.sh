#!/usr/bin/env bash
# Docker host setup (Rocky Linux 8) — installs Docker CE and runs Ghost.
# Unlike the original lab, this leaves SELinux enforcing.
# Run as root on the Docker host (10.10.229.11).
set -euo pipefail

PROXY_URL="http://10.10.229.10/blog"
HOST_PORT=3001

dnf update -y
dnf install -y epel-release nano yum-utils

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
docker --version
docker run --rm hello-world

# Replace any previous Ghost container
docker rm -f ghost 2>/dev/null || true

docker run -d --name ghost --restart unless-stopped \
  -p "${HOST_PORT}:2368" \
  -e url="${PROXY_URL}" \
  ghost

docker ps --filter name=ghost
