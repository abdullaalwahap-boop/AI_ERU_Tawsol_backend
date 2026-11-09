"""
Vercel preview build entrypoint for mobile app branch.
Prevents [FASTAPI_ENTRYPOINT_NOT_FOUND] errors when Vercel monitors the repo.
"""
from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(title="WE School Suez Tawasol Mobile App Branch")

@app.get("/")
def home():
    return JSONResponse({
        "status": "ok",
        "name": "WE School Suez Tawasol Mobile App (Flutter)",
        "message": "This branch contains the Flutter iOS and Android mobile applications."
    })
