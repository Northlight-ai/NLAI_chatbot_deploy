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
FROM nginx:bullseye

# Install Python, pip, and venv (Debian-based)
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv curl && \
    apt-get clean

# Set workdir
WORKDIR /app

# Copy backend code
COPY --from=backend /app /app

# Set up virtualenv and install Python deps
RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install -r requirements.txt

# Copy frontend build to nginx html
COPY --from=frontend /app/dist /usr/share/nginx/html

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD sh -c "/app/venv/bin/uvicorn backend.app:app --host 0.0.0.0 --port 10000 & nginx -g 'daemon off;'"
