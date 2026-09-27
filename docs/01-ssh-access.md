# 01 – SSH Access

The Ubuntu VM (10.10.229.12) acts as the admin workstation. Both Rocky Linux servers were managed from it over SSH rather than through the Proxmox console.

## Install the OpenSSH client (Ubuntu)

```bash
sudo apt update
sudo apt install openssh-client -y
```

The client was already present on this image, so apt reported it as the newest version.

## Connect to the servers

```bash
ssh root@10.10.229.11   # Docker host
ssh root@10.10.229.10   # NGINX proxy
```

On first connection SSH asks you to confirm the host's key fingerprint. Typing `yes` stores it in `~/.ssh/known_hosts`, so future connections will warn you if the server's key ever changes (a possible sign of a man-in-the-middle attack).

## Set hostnames

On each Rocky Linux server:

```bash
nmtui
```

`Set system hostname` → enter the name → `OK` → `Quit`

| IP | Hostname |
|---|---|
| 10.10.229.11 | DockerZacharias |
| 10.10.229.10 | NginxZacharias |

`hostnamectl set-hostname <name>` does the same thing without the menu.

> The lab used password login as root. See [security considerations](security-considerations.md) for the key-based alternative.
