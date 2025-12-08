from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

# GET route: example question
@router.get("/question/1")
def get_question():
    return {"question": "Print the name of NPC you just talked to!"}

# Request model for user code
class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

# POST route: just display the user code
@router.post("/question/1")
def post_user_code(request: UserCodeRequest):
    return {
        "status": "success",
        "received_code": request.user_code,
        "question_id": request.question_id
    }
