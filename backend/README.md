# NorthLightAI Chatbot Backend

This repository contains the **FastAPI-based backend** of the NorthLightAI chatbot. It performs **web scraping**, **sitemap parsing**, **embedding with Gemini**, and **retrieval-augmented generation (RAG)** using LangChain and Supabase.

---

## 📁 Project Structure

```
northlightaI_chatbot/
├── backend/
│   ├── __init__.py
│   ├── app.py              # FastAPI API
│   ├── parser.py           # Sitemap parsing functions
│   ├── rag_store.py        # Embedding + Supabase connection
│   ├── retrieval.py        # LangGraph-based retriever-generator
│   ├── scheduler.py        # Daily scraper + storage
│   └── scraper.py          # Web content scraping
├── frontend/               # (To be implemented)
├── Notebooks/
│   └── NorthLightAI_Chatbot.ipynb
├── .env                    # API keys and Supabase credentials
├── Dockerfile              # Container setup
├── requirements.txt        # Python dependencies
└── render.yaml             # Deployment config (Render + CRON)
```

---

## ⚙️ Running Locally (Docker)

### 1. Clone the repository and enter it

```bash
git clone <your-repo-url>
cd northlightaI_chatbot
```

### 2. Add a `.env` file

Create a `.env` file in the root with the following:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-supabase-service-role-key
OPENAI_API_KEY=your-openai-key
GOOGLE_API_KEY=your-gemini-api-key
```

Make sure all values are **valid and unquoted**.

---

### 3. Build the Docker container

```bash
docker build -t northlight-chatbot .
```

---

### 4. Run the backend

```bash
docker run --env-file .env -p 10000:10000 northlight-chatbot
```

You should see:

```
Uvicorn running on http://0.0.0.0:10000
```

---

## 🧪 Test the API

### Root check:

[http://localhost:10000/](http://localhost:10000/)

Expected response:

```json
{"message": "NorthLightAI Chatbot API"}
```

### Ask a question:

[http://localhost:10000/chat?query=What%20is%20North%20Light%20AI](http://localhost:10000/chat?query=What%20is%20North%20Light%20AI)

You should get a chatbot response based on your website’s content.

---

## 🔁 Rebuild After Changes

Any time you change `.py` files or `.env`:

```bash
docker build -t northlight-chatbot .
docker run --env-file .env -p 10000:10000 northlight-chatbot
```

---

## ✅ Deployment Ready

This backend is configured to be deployed on [Render.com](https://render.com) with a scheduled CRON job defined in `render.yaml`.

---

## 📌 Notes

- Uses LangChain + LangGraph for retrieval + response.
- Stores website content embeddings in Supabase.
- Supports dynamic page scraping using `requests` or `selenium`.

---

## 🛠️ TODO

- Add a frontend interface
- Add authentication if deployed publicly