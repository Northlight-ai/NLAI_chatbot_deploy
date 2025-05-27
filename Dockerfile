# --- Stage 1: Build frontend ---
FROM node:20 as frontend

WORKDIR /app
COPY frontend/playground_frontend/package*.json ./
COPY frontend/playground_frontend/.npmrc .npmrc
RUN npm install
COPY frontend/playground_frontend .
RUN npm run build

# --- Stage 2: Build backend ---
FROM python:3.11-slim as backend

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV PYTHONPATH="${PYTHONPATH}:/app"

# --- Stage 3: Final image with Python + Nginx ---
FROM python:3.11-slim

# Install Nginx and dependencies
RUN apt-get update && \
    apt-get install -y nginx curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Optional: Create non-root user (best practice)
RUN useradd -ms /bin/bash appuser

WORKDIR /app

# Copy backend code from build stage
COPY --from=backend /app /app

# Install Python packages (reuse slim pip, no venv needed here)
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy frontend static files to nginx web root
COPY --from=frontend /app/dist /var/www/html

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# ✅ Ensure no conflicting Nginx default config
RUN rm -f /etc/nginx/conf.d/default.conf

# Expose HTTP port
EXPOSE 80

# Start Uvicorn in background, Nginx in foreground
CMD sh -c "uvicorn backend.app:app --host 0.0.0.0 --port 10000 & nginx -g 'daemon off;'"
