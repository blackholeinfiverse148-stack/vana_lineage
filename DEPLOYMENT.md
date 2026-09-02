# VANA Lineage Viewer — Deployment Runbook

> **Service**: VANA / Prakriti Cross-Group Runtime Viewer
> **Type**: Static Single-Page Dashboard (Containerized via Alpine Nginx)
> **Default Port**: `5179` (Internal: `80`)

---

## 1. Architecture Overview

`vana_lineage` is packaged into an ultra-lightweight Docker image using `nginx:alpine-slim` (~10MB RAM footprint, zero CPU idle load). 

```
[ Browser ] ──HTTPS──> [ Host Nginx Reverse Proxy (SSL) ] ──HTTP──> [ Docker Container (Port 5179) ]
```

---

## 2. VM Quick Start Deployment

### A. Clone Repository
```bash
git clone https://github.com/rahilmulani025/vana_lineage.git
cd vana_lineage
```

### B. Build and Start Container
```bash
docker compose up -d --build
```

### C. Verify Container Health
```bash
# Check container status
docker ps --filter "name=bhiv_vana_lineage"

# Test healthcheck endpoint
curl http://localhost:5179/health
# Output: healthy

# Test HTML response
curl -I http://localhost:5179/
# Output: HTTP/1.1 200 OK
```

---

## 3. Host Nginx Reverse Proxy Configuration

Add the following block to your host Nginx configuration (e.g. `/etc/nginx/sites-available/` or `nginx.ssl.conf`):

### Option 1: Dedicated Subdomain (`lineage.blackholeinfiverse.com`)

```nginx
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name lineage.blackholeinfiverse.com;
    client_max_body_size 20M;

    ssl_certificate /etc/letsencrypt/live/lineage.blackholeinfiverse.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/lineage.blackholeinfiverse.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';

    # Security Headers
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
    add_header X-Frame-Options SAMEORIGIN always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;

    location / {
        proxy_pass http://127.0.0.1:5179;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Option 2: Path-Based Routing on Existing Domain (`niyantran.blackholeinfiverse.com/lineage/`)

```nginx
location /lineage/ {
    proxy_pass http://127.0.0.1:5179/;
    proxy_http_version 1.1;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

---

## 4. Operational & Troubleshooting Commands

```bash
# View container logs
docker logs -f bhiv_vana_lineage

# Restart container
docker compose restart

# Stop container
docker compose down
```
