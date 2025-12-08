from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Hello, This is your backend!"}

@app.get("/question/1")
def question_one():
    return {"question": "This is question 1"}