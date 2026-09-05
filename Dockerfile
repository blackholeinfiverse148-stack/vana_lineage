# ==============================================================================
# VANA Lineage Viewer - Minimal Static Production Image
# Multi-arch ready, lightweight Alpine Nginx runtime (<15MB image footprint)
# ==============================================================================
FROM nginx:alpine-slim

# Remove default nginx configurations and static files
RUN rm -rf /etc/nginx/conf.d/default.conf /usr/share/nginx/html/*

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static viewer HTML as index.html
COPY *.html /usr/share/nginx/html/index.html

# Expose HTTP port
EXPOSE 80

# Production Health Check
HEALTHCHECK --interval=30s --timeout=3s --retries=3 --start-period=5s \
  CMD wget -q --spider http://localhost:80/health || exit 1

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
