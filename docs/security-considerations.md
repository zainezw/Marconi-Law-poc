# Security Considerations

This lab followed the course steps, several of which trade security for simplicity. That's acceptable on an isolated classroom network. Below is what each shortcut exposes and how I'd handle it for a real client.

## SELinux disabled

**Risk:** SELinux confines each service to what it's supposed to do. If NGINX were compromised, SELinux would limit what the attacker could read or execute. Disabling it removes that layer entirely.

**Production approach:** Keep SELinux enforcing and grant only the permission NGINX needs:

```bash
sudo setsebool -P httpd_can_network_connect 1
```

## firewalld disabled

**Risk:** Every listening service on the host becomes reachable from the network.

**Production approach:** Keep firewalld on and open only what's required:

```bash
# NGINX proxy
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

On the Docker host, port 3001 should accept connections from the proxy (10.10.229.10) only, so users can't bypass NGINX. Note that Docker writes its own iptables rules for published ports, which can bypass firewalld zones; the `DOCKER-USER` chain is the place to restrict them.

## Root login with a password over SSH

**Risk:** Password logins can be brute-forced, and logging in as root means any mistake or compromise has full privileges.

**Production approach:** Use SSH keys, log in as a normal user with `sudo`, and set `PermitRootLogin no` and `PasswordAuthentication no` in `/etc/ssh/sshd_config`.

## No TLS

**Risk:** Traffic between browser and proxy is plaintext.

**Production approach:** Terminate HTTPS at NGINX (for example with Let's Encrypt) and redirect port 80 to 443. This fits the reverse proxy design, since only the proxy needs a certificate.

## Defense in depth

The architecture itself is a defense-in-depth win: users only ever talk to the proxy, the application runs isolated in a container, and each tier can be secured independently. Milestone 3 adds application-layer controls on WordPress (file permissions, `wp-config.php` protection, and a Layer 7 firewall plugin).
