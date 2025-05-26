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

# ✅ Define full path to static directory
static_path = os.path.join(os.path.dirname(__file__), "..", "static")

# ✅ Mount the static frontend build folder
app.mount("/static", StaticFiles(directory=static_path, html=True), name="static")

# Serve the React index.html for "/"
@app.get("/")
async def serve_index():
    return FileResponse(os.path.join(static_path, "index.html"))

# React Router support — catch-all route
@app.get("/{full_path:path}")
async def catch_all(full_path: str):
    index_file = os.path.join(static_path, "index.html")
    if os.path.exists(index_file):
        return FileResponse(index_file)
    return {"error": "Frontend not found"}

# Your chatbot API route
@app.get("/chat")
def chat(query: str = Query(..., description="User question")):
    answer = get_answer(query)
    return {"answer": answer}
