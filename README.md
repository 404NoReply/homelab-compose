A collection of ready to use Docker Compose files, necessary configuration files, and short instructions to help you deploy and manage self hosted apps in your home lab or personal server.

All setups use caddy as a reverse proxy, which automatically handles SSL/TLS certificates, and we expose only ports 80 and 443 for secure HTTPS access. Ideal for hobbyists and anyone looking to take control of their software environment.

You can install Docker using the official convenience script:

```sh
curl -fsSL https://get.docker.com | sh
```