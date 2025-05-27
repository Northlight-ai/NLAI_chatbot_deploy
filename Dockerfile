# --- Stage 1: Build frontend ---
FROM node:20 as frontend
WORKDIR /app
COPY frontend/playground_frontend/package*.json ./
RUN npm install
COPY frontend/playground_frontend/ .
RUN npm run build

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

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/sites-enabled/default

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Create log directory
RUN mkdir -p /var/log

# Ensure nginx can write to temp directories
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R www-data:www-data /var/cache/nginx

# Expose HTTP port
EXPOSE 80

# Run both backend and nginx through supervisor
CMD ["supervisord", "-c", "/etc/supervisord.conf"]