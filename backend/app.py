from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os

from backend.retrieval import get_answer

app = FastAPI(title="NorthLightAI Chatbot")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Mount the built frontend files
app.mount("/static", StaticFiles(directory="static", html=True), name="static")

# Serve frontend from root
@app.get("/")
async def serve_index():
    return FileResponse("static/index.html")

# Optional: Catch-all for React Router paths
@app.get("/{full_path:path}")
async def catch_all(full_path: str):
    file_path = os.path.join("static", "index.html")
    if os.path.exists(file_path):
        return FileResponse(file_path)
    return {"error": "Frontend not found"}

# API route
@app.get("/chat")
def chat(query: str = Query(..., description="User question")):
    answer = get_answer(query)
    return {"answer": answer}