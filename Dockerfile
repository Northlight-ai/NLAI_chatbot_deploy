# --- Stage 1: Build frontend ---
FROM node:20 AS frontend

WORKDIR /app
COPY frontend/playground_frontend/package*.json ./
COPY frontend/playground_frontend/ ./
RUN npm install && npm run build

# --- Stage 2: Build backend ---
FROM python:3.11-slim AS backend

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV PYTHONPATH="${PYTHONPATH}:/app"

# --- Stage 3: Final image with Supervisor, Nginx, and Backend ---
FROM python:3.11-slim

# ✅ Install system tools, Nginx, Supervisor, Uvicorn
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    supervisor \
    nginx \
    netcat-openbsd \
    ca-certificates \
    gnupg && \
    pip install --no-cache-dir uvicorn && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy backend
COPY --from=backend /app /app

# Copy frontend built files to Nginx root
COPY --from=frontend /app/dist /var/www/html

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

# Nginx temp/cache dirs and ownership
RUN mkdir -p /var/log /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R www-data:www-data /var/cache/nginx

# ✅ Validate Nginx config
RUN nginx -t || (echo "❌ Nginx config invalid" && exit 1)

EXPOSE 10000
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
