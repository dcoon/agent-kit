---
name: zoraxy
description: "Zoraxy reverse proxy administration from the CLI. Use when: configuring Zoraxy proxy rules, virtual directories, TLS/ACME certificates, Docker or systemd deployment, config-file routing, uptime monitoring, or when the user mentions zoraxy, the zoraxy web UI on port 8000, or migrating from Nginx Proxy Manager."
---

# Zoraxy

Zoraxy (github.com/tobychui/zoraxy) is a Go reverse proxy and forwarding tool. One binary, one management port (default `:8000`) serving both the web UI and the REST API, single-admin auth. Flags vary between versions — run `zoraxy -version` and `zoraxy -help` before relying on any parameter.

## Start parameters (verified v3.x README)

| Flag | Default | Notes |
|---|---|---|
| `-port` | `:8000` | Management web UI + API |
| `-conf` | `./conf` | Config folder (incl. `conf/proxy/`) |
| `-webroot` | `./www` | Static web server root, start-param only |
| `-db` | `auto` | `leveldb`, `boltdb`, `auto`; fsdb on unsupported platforms |
| `-dbpath` | `./sys.db` | |
| `-log` / `-enablelog` | `./log` / true | |
| `-plugin` | `./plugins` | |
| `-tmp` | `./tmp` | |
| `-uuid` | `./sys.uuid` | |
| `-mdns` | true | Disable for quiet LANs |
| `-noauth` | false | Disable management auth — only with an auth proxy in front |
| `-reset_ac` | — | Reset admin account to default, then exit |
| `-docker` | false | Docker compatibility mode |
| `-acmetestmode` | false | ACME staging (Let's Encrypt test) |
| `-autorenew` / `-earlyrenew` | 86400s / 30d | ACME renewal check interval / early-renew days |
| `-default_inbound_port` | 443 | Web server port |
| `-fastgeoip` | false | Faster geoip, +1 GB RAM |
| `-sshlb` | false | Allow loopback Web SSH (DANGER) |

## Routing via config files (verified, v3.1.7+)

Proxy rules can be declared as JSON in `conf/proxy/<hostname>.config`; Zoraxy loads them at startup. Core fields:

```json
{
  "ProxyType": 1,
  "RootOrMatchingDomain": "test1.localhost",
  "MatchingDomainAlias": ["test2.localhost"],
  "ActiveOrigins": [
    {
      "OriginIpOrDomain": "example.com",
      "RequireTLS": true,
      "SkipCertValidations": false,
      "SkipWebSocketOriginCheck": true,
      "Weight": 1,
      "MaxConn": 0
    }
  ],
  "InactiveOrigins": [],
  "UseStickySession": false,
  "UseActiveLoadBalance": false,
  "Disabled": false,
  "BypassGlobalTLS": false,
  "VirtualDirectories": [
    {
      "MatchingPath": "/firework/",
      "Domain": "example.com/fw/",
      "RequireTLS": true,
      "SkipCertValidations": false,
      "Disabled": false
    }
  ],
  "HeaderRewriteRules": {
    "UserDefinedHeaders": [],
    "RequestHostOverwrite": "",
    "HSTSMaxAge": 0
  }
}
```

The full schema includes per-origin load balancing and a large `PermissionPolicy` block — inspect an existing `.config` on the target install before writing new ones. Changes require a Zoraxy restart/reload to take effect.

## Docker deployment (official compose)

Image `zoraxydocker/zoraxy`. The `docker.sock` mount is used for container discovery and grants host root equivalent access — only mount it if that feature is wanted.

```yaml
services:
  zoraxy:
    image: zoraxydocker/zoraxy:latest
    container_name: zoraxy
    restart: unless-stopped
    ports:
      - 80:80
      - 443:443
      - 443:443/udp   # only needed if QUIC (HTTP/3) is enabled in Global Settings
      - 8000:8000
    volumes:
      - /path/to/zoraxy/config/:/opt/zoraxy/config/
      - /path/to/zoraxy/plugin/:/opt/zoraxy/plugin/
      - /var/run/docker.sock:/var/run/docker.sock
    extra_hosts:
      - "host.docker.internal:host-gateway"
    environment:
      FASTGEOIP: "true"
      TZ: "America/New_York"
```

To reach host-network services (e.g. hostdb:5432) use `host.docker.internal`, not `localhost`. A bridge network will not see other containers' published ports unless they share a user-defined network or Zoraxy runs with `network_mode: host`.

## systemd (binary mode)

```ini
[Unit]
Description=Zoraxy Reverse Proxy
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/opt/zoraxy/zoraxy -port=:8000 -conf=/opt/zoraxy/conf
WorkingDirectory=/opt/zoraxy
Restart=on-failure
# 80/443 need CAP_NET_BIND_SERVICE or run as root
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
```

`-webroot`, `-dbpath`, `-uuid` and `-log` defaults are relative to the working directory — set `WorkingDirectory` deliberately.

## Auth and the REST API

- Single admin account, created on first web-UI login at `http://<host>:8000`.
- REST API lives under `/api/` on the management port and authenticates with the same admin session.
- **Do not guess endpoint paths.** They change between versions. Discover them from the web UI's network tab (browser devtools) or from source at `src/web/` in the repo for the installed version.
- `-noauth` removes management auth entirely; acceptable only behind another authenticating proxy.

## TLS / ACME

- Built-in ACME with auto-renew (`-autorenew`, `-earlyrenew`). DNS challenge supported for Let's Encrypt via lego DNS providers (https://go-acme.github.io/lego/dns/) — needed for wildcard certs.
- Test against staging first with `-acmetestmode` to avoid rate limits.
- SNI and SAN (multi-domain) certs supported.

## Files to back up / migrate

Copy these to move an install: `conf/`, `sys.db`, `sys.uuid`, `www/`, and the certificate store. In Docker everything persists under the mounted `/opt/zoraxy/config/` volume. Never back up `tmp/`.

## Gotchas

- Config-file routing schema is version-dependent (v3.1.7 format shown above).
- mDNS is on by default; it advertises `zoraxy_<uuid>.local` on the LAN.
- Web SSH to localhost/127.0.0.1 is rejected unless `-sshlb=true`.
- 80/443 binding needs root or CAP_NET_BIND_SERVICE.
- `443/udp` port mapping matters only when QUIC/HTTP3 is enabled.