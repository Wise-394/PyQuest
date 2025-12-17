from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/2/question/2")
def get_question():
    code = "more_than_10 = 0"
    return {"question": "Print the variable with a value more than 10", "code": code}

@router.post("/level/2/question/2")
def post_user_code(request: UserCodeRequest):
    output = execute_user_code(request.user_code).strip()
    
    try:
        value = float(output)
        is_correct = value > 10
        
        message = (
            f"{output}\nCorrect!"
            if is_correct
            else f"{output}\nWrong, print a value greater than 10"
        )
    except (ValueError, TypeError):
        is_correct = False
        message = f"{output}\nWrong, print a value greater than 10"
    
    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": ""
    }