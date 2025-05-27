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

COPY --from=backend /app /app

COPY --from=frontend /app/dist /var/www/html

COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
