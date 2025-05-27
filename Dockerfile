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

# --- Stage 3: Final stage with nginx and both apps ---
FROM nginx:alpine

# Install Python, pip, and venv
RUN apk add --no-cache python3 py3-pip py3-virtualenv bash

# Set workdir
WORKDIR /app

# Copy backend code
COPY --from=backend /app /app

# Create and activate a virtual environment
RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --no-cache-dir uvicorn -r requirements.txt

# Copy built frontend to nginx html
COPY --from=frontend /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Start uvicorn in background and nginx in foreground
CMD sh -c "/app/venv/bin/uvicorn backend.app:app --host 0.0.0.0 --port 10000 & nginx -g 'daemon off;'"