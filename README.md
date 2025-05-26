# North Light AI Chatbot

This project is a full-stack AI chatbot with a FastAPI backend and a Vite + React + ShadCN UI frontend. It is fully containerized using Docker.

## 🐳 How to Run with Docker

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/northlightai_chatbot.git
cd northlightai_chatbot
```

### 2. Dockerize the App

Make sure your folder structure looks like this:

```
.
├── backend/
│   ├── app.py
│   ├── retrieval/
│   ├── requirements.txt
│   └── ...
├── frontend/
│   └── playground_frontend/
│       ├── Dockerfile
│       ├── package.json
│       ├── src/
│       └── ...
├── Dockerfile           # Backend Dockerfile
├── docker-compose.yaml
└── .env
```

### 3. Build and Run the Containers

```bash
docker-compose up --build
```

This will:

- Build the backend image from the root `Dockerfile`
- Build the frontend image from `frontend/full_page_frontend/Dockerfile`
- Run both containers and connect them via Docker network

### 4. Access the App

- Frontend: <http://localhost:8080>
- Backend: <http://localhost:10000>

You can test the backend with:

```
http://localhost:10000/chat?query=hello
```

### 5. Stop Containers

```bash
docker-compose down
```

### 6. Restart Without Rebuilding

```bash
docker-compose up
```

or in detached mode:

```bash
docker-compose up -d
```

---

## 🛠️ Notes

- The frontend build uses `serve` to statically serve the Vite build.
- The backend uses `uvicorn` to serve the FastAPI app.
- The two services communicate within Docker using the service name (`backend`) instead of `localhost`.

Happy hacking! 🎉
