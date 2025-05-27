from fastapi import FastAPI, APIRouter, Query
from fastapi.middleware.cors import CORSMiddleware
from backend.retrieval import get_answer

app = FastAPI(title="NorthLightAI Chatbot")

router = APIRouter()

@router.get("/")
def root():
    return {"message": "NorthLightAI Chatbot API"}

@router.get("/chat")
def chat(query: str = Query(..., description="User question")):
    answer = get_answer(query)
    return {"answer": answer}

app.include_router(router, prefix="/api")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
