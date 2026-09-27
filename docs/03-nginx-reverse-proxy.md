# 03 – NGINX Reverse Proxy

Host: **NginxZacharias** · Rocky Linux 8 · 10.10.229.10

## Prepare the host

```bash
sudo yum update -y
sudo yum install epel-release -y
sudo yum install nano -y
```

## SELinux and firewall (lab steps)

```bash
sudo nano /etc/selinux/config    # SELINUX=enforcing → SELINUX=disabled
reboot
sestatus

sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

See [security considerations](security-considerations.md) for why this matters and what to do instead.

## Install and start NGINX

```bash
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
systemctl status nginx
```

## Configure the reverse proxy

A `location /blog` block was added to the default server in `/etc/nginx/nginx.conf`:

```nginx
location /blog {
    proxy_pass          http://10.10.229.11:3001;
    proxy_set_header    Host              $http_host;                  # required for Docker client
    proxy_set_header    X-Real-IP         $remote_addr;                # pass on real client IP
    proxy_set_header    X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_read_timeout  900;
}
```

The same block is saved in [`configs/nginx/default.d/ghost-blog.conf`](../configs/nginx/default.d/ghost-blog.conf). On Rocky Linux the default server already runs `include /etc/nginx/default.d/*.conf;`, so dropping the file there is cleaner than editing `nginx.conf` directly.

The forwarded headers matter for security as well as function: without `X-Real-IP` and `X-Forwarded-For`, every request in Ghost's logs would appear to come from the proxy, which makes incident investigation much harder.

## Apply the change

```bash
sudo nginx -t                    # validate syntax before reloading
sudo systemctl reload nginx      # apply without dropping connections
```
