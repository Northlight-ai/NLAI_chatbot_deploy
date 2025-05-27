from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
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

@app.get("/")
def root():
    return {"message": "NorthLightAI Chatbot API"}

@app.get("/chat")
def chat(query: str = Query(..., description="User question")):
    answer = get_answer(query)
    return {"answer": answer}
