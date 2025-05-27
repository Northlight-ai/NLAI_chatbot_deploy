# 1. Base image for both backend and frontend build
FROM python:3.11-slim AS base

# Install system dependencies
RUN apt-get update && \
    apt-get install -y nginx supervisor nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# 2. Build the frontend (Vite/React)
FROM node:20 AS frontend-builder

WORKDIR /app/frontend/playground_frontend

# Copy frontend only
COPY frontend/playground_frontend/package*.json ./
COPY frontend/playground_frontend/ ./

RUN npm install && npm run build

# 3. Backend build (in main Python image)
FROM base AS backend

WORKDIR /app

# Copy backend code
COPY backend/ ./backend

# Install Python requirements if you have one
# If you want to use requirements.txt at root, else skip
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 4. Final image
FROM base

WORKDIR /app

# Copy built frontend from builder
COPY --from=frontend-builder /app/frontend/playground_frontend/dist /app/frontend_dist

# Copy backend
COPY backend/ ./backend

# Copy requirements and re-install in final (for safety, uses cache)
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy nginx/supervisord configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

# Copy frontend static files into nginx default directory
RUN rm -rf /var/www/html && \
    ln -s /app/frontend_dist /var/www/html

# Make nginx log to stdout/stderr (for Docker/Render)
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Expose port 80 for nginx
EXPOSE 80

# Start supervisord to run both Nginx and Uvicorn
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
