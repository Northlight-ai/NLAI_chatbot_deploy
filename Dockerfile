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

# Copy built frontend to Nginx html
COPY --from=frontend /app/dist /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy backend
COPY --from=backend /app /app

# Install Python & Uvicorn
RUN apk add --no-cache python3 py3-pip && \
    pip install --no-cache-dir uvicorn

EXPOSE 80

# Start both Nginx and backend
CMD sh -c "uvicorn backend.app:app --host 0.0.0.0 --port 10000 & nginx -g 'daemon off;'"
