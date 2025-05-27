# --- Stage 1: Build frontend ---
FROM node:20 as frontend
WORKDIR /app
COPY frontend/playground_frontend/package*.json ./
RUN npm install
COPY frontend/playground_frontend/ .
RUN npm run build

# Debug: Check what was built
RUN echo "=== FRONTEND BUILD OUTPUT ===" && \
    ls -la /app/ && \
    echo "=== DIST FOLDER CONTENTS ===" && \
    ls -la /app/dist/ 2>/dev/null || echo "No dist folder found"

# --- Stage 2: Build backend ---
FROM python:3.11-slim as backend
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ ./backend/
COPY *.py ./
ENV PYTHONPATH="${PYTHONPATH}:/app"

# --- Stage 3: Final image ---
FROM python:3.11-slim

# Install Nginx and dependencies
RUN apt-get update && \
    apt-get install -y nginx curl supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy backend
COPY --from=backend /app /app

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install "uvicorn[standard]" && pip install -r /app/requirements.txt

# Copy frontend files
COPY --from=frontend /app/dist /var/www/html

# Debug: Check if frontend files were copied
RUN echo "=== CHECKING /var/www/html ===" && \
    ls -la /var/www/html/ && \
    echo "=== CHECKING FOR INDEX.HTML ===" && \
    if [ -f /var/www/html/index.html ]; then \
    echo "✅ index.html EXISTS"; \
    head -5 /var/www/html/index.html; \
    else \
    echo "❌ index.html MISSING"; \
    fi

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
RUN rm -f /etc/nginx/sites-enabled/default

# Test nginx config
RUN nginx -t && echo "✅ Nginx config valid" || echo "❌ Nginx config invalid"

# Create directories
RUN mkdir -p /var/log /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R www-data:www-data /var/cache/nginx

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]