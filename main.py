"""
Vercel preview build entrypoint for mobile app branch.
Prevents [FASTAPI_ENTRYPOINT_NOT_FOUND] errors when Vercel monitors the repo.
"""
from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(title="AI ERU Tawasol Mobile App Branch")

@app.get("/")
def home():
    return JSONResponse({
        "status": "ok",
        "name": "AI ERU Tawasol Mobile App (Flutter)",
        "message": "This branch contains the Flutter iOS and Android mobile applications."
    })
