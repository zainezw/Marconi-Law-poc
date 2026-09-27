# 04 – Verification and Logs

## Browser test

From Firefox on the Ubuntu VM, browse to:

```
http://10.10.229.10/blog
```

## Log review

```bash
tail /var/log/nginx/access.log
tail /var/log/nginx/error.log
```

`tail` shows the last 10 lines of a file. `tail -f` follows the file live, which is useful for watching requests arrive while you test in a browser.

The access log showed requests from the Ubuntu workstation (10.10.229.12) for `/blog` and page assets, with the Firefox user agent. The error log was empty at the time of review.

## Troubleshooting: "nginx error!" page

The first browser test returned NGINX's default error page ("the page you are looking for is temporarily unavailable"), which the course noted could happen. This page comes from a 5xx response, usually a 502 Bad Gateway, meaning NGINX was up but couldn't get a good response from the backend.

Things I'd check, in order:

1. **Is Ghost running?** `docker ps` on the Docker host. Ghost takes a little while to finish starting after `docker run`, so an early request can fail.
2. **Can the proxy reach the backend?** From the NGINX host: `curl -I http://10.10.229.11:3001`
3. **Is the Ghost `url` exact?** It must be `http://10.10.229.10/blog`, including the `//`.
4. **What does the error log say?** `tail -f /var/log/nginx/error.log` while reloading the page shows the exact upstream error.
5. **Is SELinux blocking the proxy?** On an enforcing system, NGINX can't open outbound connections unless `httpd_can_network_connect` is on.
