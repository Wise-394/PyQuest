from fastapi import APIRouter

router = APIRouter()

@router.get("/question/2")
def q1():
    return {"question": "This is question 2"}