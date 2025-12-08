from fastapi import FastAPI
from question import routers

app = FastAPI()

for r in routers:
    app.include_router(r)

@app.get("/")
def home():
    return {"message": "Hello, This is your backend!"}