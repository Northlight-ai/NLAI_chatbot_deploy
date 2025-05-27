# ---- 1. Build frontend ----
FROM node:20 as frontend-build
WORKDIR /frontend
COPY frontend/playground_frontend ./playground_frontend
WORKDIR /frontend/playground_frontend
RUN npm install && npm run build

# ---- 2. Build backend ----
FROM python:3.11-slim as backend-build
WORKDIR /app
COPY backend ./backend
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- 3. Final image ----
FROM python:3.11-slim

# System dependencies for nginx and supervisor
RUN apt-get update && \
    apt-get install -y nginx supervisor && \
    rm -rf /var/lib/apt/lists/*

# Create required folders
WORKDIR /app

# Copy backend code and dependencies
COPY --from=backend-build /app/backend ./backend
COPY --from=backend-build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY requirements.txt .

# Copy built frontend
COPY --from=frontend-build /frontend/playground_frontend/dist /app/frontend_dist

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

# Logs symlinks for Docker best practices
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
