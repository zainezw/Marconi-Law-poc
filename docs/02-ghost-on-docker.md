# 02 – Ghost on Docker

Host: **DockerZacharias** · Rocky Linux 8 · 10.10.229.11

## Prepare the host

```bash
sudo yum update -y
sudo yum install epel-release -y
sudo yum install nano -y
```

## Add the Docker CE repository

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

## Install Docker CE

```bash
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker -v
```

## Start, enable, and test Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker     # start on boot
sudo docker run hello-world      # confirms the daemon can pull and run images
```

## SELinux (lab step)

The lab disabled SELinux on this host:

```bash
sudo nano /etc/selinux/config    # SELINUX=enforcing → SELINUX=disabled
reboot
sestatus                         # SELinux status: disabled
```

## Deploy Ghost

The first container was created with Ghost's URL set to the Docker host itself. Once the reverse proxy was in place, it was replaced with one whose URL points at the proxy path, so Ghost generates links through NGINX instead of exposing the backend.

```bash
docker ps -a                     # find the existing container ID
docker kill <container-id>
docker rm <container-id>

docker run -d --name ghost -p 3001:2368 \
  -e url=http://10.10.229.10/blog \
  ghost
```

`-p 3001:2368` maps host port 3001 to Ghost's internal port 2368. The `url` variable tells Ghost its public address.

```bash
docker ps -a                     # confirm the container is up
```
