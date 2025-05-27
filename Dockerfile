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

# --- Stage 3: Final image with Nginx + FastAPI ---
FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y nginx supervisor curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Optional: Create non-root user
RUN useradd -ms /bin/bash appuser
WORKDIR /app

# Copy backend from build stage
COPY --from=backend /app /app

# Copy frontend static files from build stage
COPY --from=frontend /app/dist /var/www/html

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Remove default site if exists
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy supervisord config
COPY supervisord.conf /etc/supervisord.conf

# Expose port Nginx listens on
EXPOSE 80

# Run both Nginx and FastAPI via supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
