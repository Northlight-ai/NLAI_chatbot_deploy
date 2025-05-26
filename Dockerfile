# Stage 1: Build Frontend
FROM node:20 AS frontend-builder

# Set working directory for frontend
WORKDIR /app

# Copy only frontend source
COPY frontend/playground_frontend ./frontend

# Move into frontend folder
WORKDIR /app/frontend

# Install and build frontend
RUN npm install && npm run build


# Stage 2: Backend with Frontend
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy backend source
COPY backend ./backend

# Copy frontend build into static folder in backend
COPY --from=frontend-builder /app/frontend/dist ./static

# Copy root-level requirements.txt
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set PYTHONPATH so "from backend.xxx import yyy" works
ENV PYTHONPATH=/app

# Expose the port and start FastAPI with uvicorn
ENV PORT=8000
CMD ["uvicorn", "backend.app:app", "--host", "0.0.0.0", "--port", "8000"]
