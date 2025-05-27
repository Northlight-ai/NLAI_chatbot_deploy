from fastapi import FastAPI, Query, APIRouter
from fastapi.middleware.cors import CORSMiddleware
from backend.retrieval import get_answer

# Create API router
router = APIRouter()

@router.get("/")
def root():
    return {"message": "NorthLightAI Chatbot API"}

@router.get("/chat")
def chat(query: str = Query(..., description="User question")):
    answer = get_answer(query)
    return {"answer": answer}

# Create FastAPI app
app = FastAPI(title="NorthLightAI Chatbot")

# Mount router at /api
app.include_router(router, prefix="/api")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)
