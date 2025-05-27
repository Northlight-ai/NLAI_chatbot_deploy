# 1. Build the frontend
FROM node:20 AS frontend-build
WORKDIR /app/frontend/playground_frontend
COPY frontend/playground_frontend/package*.json ./
RUN npm install
COPY frontend/playground_frontend ./
RUN npm run build

# 2. Main image with backend and nginx
FROM python:3.11-slim

# Install OS dependencies
RUN apt-get update && apt-get install -y nginx supervisor

# Backend requirements
WORKDIR /app
COPY backend/requirements.txt ./backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy backend code
COPY backend ./backend

# Copy frontend build to nginx html
COPY --from=frontend-build /app/frontend/playground_frontend/dist /var/www/frontend

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

# Set up nginx www permissions
RUN chown -R www-data:www-data /var/www/frontend

# Expose HTTP port
EXPOSE 80

# Start supervisor to run both nginx and uvicorn
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
