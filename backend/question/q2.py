from fastapi import APIRouter

router = APIRouter()

@router.get("/question/2")
def q1():
    return {"message": "This is question 2"}