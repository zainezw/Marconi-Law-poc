#!/usr/bin/env bash
# NGINX reverse proxy setup (Rocky Linux 8).
# Unlike the original lab, this keeps SELinux enforcing and firewalld running,
# opening only HTTP/HTTPS. Run as root from the repo root on the proxy (10.10.229.10).
set -euo pipefail

dnf update -y
dnf install -y epel-release nano nginx

# Allow NGINX to make outbound connections to the backend under SELinux
setsebool -P httpd_can_network_connect 1

systemctl enable --now firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

cp configs/nginx/default.d/ghost-blog.conf /etc/nginx/default.d/ghost-blog.conf

nginx -t
systemctl enable --now nginx
systemctl reload nginx

echo "Test with: curl -I http://10.10.229.10/blog"
