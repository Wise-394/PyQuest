from fastapi import APIRouter

router = APIRouter()

@router.get("/question/1")
def q1():
    return {"message": "This is question 1"}