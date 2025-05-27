# --- Stage 1: Build frontend ---
FROM node:20 as frontend

WORKDIR /app
COPY frontend/playground_frontend/package*.json ./
COPY frontend/playground_frontend/ .
RUN npm install && npm run build

# --- Stage 2: Build backend ---
FROM python:3.11-slim as backend

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
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
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Expose HTTP port
EXPOSE 80

# Run both backend and nginx through supervisor
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
