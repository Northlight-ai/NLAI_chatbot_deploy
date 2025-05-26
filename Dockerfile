# Stage 1: Build Frontend
FROM node:20 AS frontend-builder
WORKDIR /app
COPY frontend/playground_frontend ./frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Stage 2: Backend with frontend build included
FROM python:3.13

# Set working directory
WORKDIR /app

# Copy backend code
COPY backend ./backend

# Copy frontend build into backend/static
COPY --from=frontend-builder /app/frontend/dist ./backend/static

# Install Python dependencies
WORKDIR /app/backend
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port and start FastAPI
ENV PORT=8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
