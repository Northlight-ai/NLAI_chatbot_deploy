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

# ✅ Install system tools, Nginx, Supervisor, and Uvicorn
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


# Set working directory
WORKDIR /app

# Copy backend code
COPY --from=backend /app /app

# Copy frontend built static files to nginx web root
COPY --from=frontend /app/dist /var/www/html

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Optional: set ownership for Nginx cache
RUN mkdir -p /var/log /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R www-data:www-data /var/cache/nginx

# ✅ Test Nginx config
RUN nginx -t && echo "✅ Nginx config valid" || echo "❌ Nginx config invalid"

# Expose the public port (Render will detect 10000)
EXPOSE 10000

# Start both backend and nginx using supervisor
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
