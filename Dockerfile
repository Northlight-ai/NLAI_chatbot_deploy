# --- Stage 1: Build frontend ---
FROM node:20 AS frontend
WORKDIR /app
COPY frontend/playground_frontend/package*.json ./
RUN npm install
COPY frontend/playground_frontend/ .
RUN npm run build

# --- Stage 2: Build backend ---
FROM python:3.11-slim AS backend
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# --- Stage 3: Final combined image ---
FROM nginx:1.22 as final
COPY --from=frontend /app/dist /var/www/html
COPY --from=backend /app /app

# Copy Nginx and Supervisor configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

# Install Uvicorn and Supervisor
RUN apt-get update && \
    apt-get install -y supervisor curl && \
    pip install uvicorn && \
    rm -rf /var/lib/apt/lists/*

# Clean up Nginx default conf
RUN rm -f /etc/nginx/conf.d/default.conf && \
    mkdir -p /var/log /var/cache/nginx/client_temp && \
    chown -R www-data:www-data /var/cache/nginx

EXPOSE 80
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
