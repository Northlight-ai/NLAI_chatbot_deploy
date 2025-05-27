# Base image for Python (backend)
FROM python:3.11-slim

# Set up Python backend
WORKDIR /app

# Install backend dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the full project
COPY . .

# Set PYTHONPATH so backend modules resolve
ENV PYTHONPATH="${PYTHONPATH}:/app"

# -----------------------------
# Install Node for frontend
# -----------------------------
# Install Node.js manually because slim image doesn’t have it
RUN apt-get update && apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory for frontend build
WORKDIR /app/frontend/playground_frontend

# Install frontend deps & build
COPY frontend/playground_frontend/package*.json ./
COPY frontend/playground_frontend/.npmrc .npmrc
RUN npm install
COPY frontend/playground_frontend ./
RUN npm run build
RUN npm install -g serve

# -----------------------------
# Install supervisor to run both
# -----------------------------
RUN apt-get update && apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080
EXPOSE 10000

# Start both services
CMD ["/usr/bin/supervisord"]
