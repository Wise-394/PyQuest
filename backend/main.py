from fastapi import FastAPI
from question import routers

app = FastAPI()

for r in routers:
    app.include_router(r)
    print(f"Routes: {[route.path for route in r.routes]}")

@app.get("/")
def home():
    return {"message": "Hello, This is your backend!"}