# --- Stage 1: Build frontend ---
FROM node:20 as frontend
WORKDIR /app
COPY frontend/playground_frontend/package*.json ./
RUN npm install
COPY frontend/playground_frontend/ .
RUN npm run build

# Debug: List what was built
RUN echo "=== Frontend build contents ===" && ls -la dist/ && echo "=== End frontend contents ==="

# --- Stage 2: Build backend ---
FROM python:3.11-slim as backend
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ ./backend/
COPY *.py ./
ENV PYTHONPATH="${PYTHONPATH}:/app"

# --- Stage 3: Final image with Python + Nginx + Supervisor ---
FROM python:3.11-slim

# Install Nginx and dependencies
RUN apt-get update && \
    apt-get install -y nginx curl supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy backend from stage 2
COPY --from=backend /app /app

# Reinstall requirements + uvicorn (ensure it's available)
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install "uvicorn[standard]" && pip install -r /app/requirements.txt

# Copy built frontend files
COPY --from=frontend /app/dist /var/www/html

# Debug: Verify frontend files were copied
RUN echo "=== Checking /var/www/html contents ===" && \
    ls -la /var/www/html/ && \
    echo "=== End /var/www/html contents ===" && \
    if [ -f /var/www/html/index.html ]; then echo "✅ index.html found"; else echo "❌ index.html NOT found"; fi

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Debug: Verify config files
RUN echo "=== Checking nginx config ===" && \
    nginx -t && \
    echo "✅ Nginx config is valid" && \
    echo "=== Checking supervisord config ===" && \
    ls -la /etc/supervisord.conf

# Create log directory and set permissions
RUN mkdir -p /var/log /var/run && \
    mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R www-data:www-data /var/cache/nginx /var/log/nginx* || true

# Create nginx run directory
RUN mkdir -p /var/lib/nginx

# Expose HTTP port
EXPOSE 80

# Debug startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "=== Starting services ==="' >> /start.sh && \
    echo 'echo "Checking if frontend files exist:"' >> /start.sh && \
    echo 'ls -la /var/www/html/' >> /start.sh && \
    echo 'echo "Starting supervisord..."' >> /start.sh && \
    echo 'exec supervisord -c /etc/supervisord.conf' >> /start.sh && \
    chmod +x /start.sh

# Use debug startup script
CMD ["/start.sh"]