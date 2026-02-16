import sys
import os
import multiprocessing
from fastapi import FastAPI
import uvicorn

if getattr(sys, 'frozen', False):
    os.chdir(sys._MEIPASS)

from question import routers

app = FastAPI()

for r in routers:
    app.include_router(r)

@app.get("/")
def home():
    return {"message": "Hello, This is your backend!"}

@app.get("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    multiprocessing.freeze_support()
    uvicorn.run(
        app,
        host="127.0.0.1",
        port=8000,
        log_config=None
    )