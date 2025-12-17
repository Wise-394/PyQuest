from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/2/question/1")
def get_question():
    code = "variable = 'hello! Im a variable'"
    return {"question": "How do u print the variable?", "code": code}

@router.post("/level/2/question/1")
def post_user_code(request: UserCodeRequest):
    output = execute_user_code(request.user_code).strip()
    expected_answer = "hello! im a variable"
    is_correct = output.lower() == expected_answer
    
    message = (
        f"{output}\nCorrect!"
        if is_correct
        else f"{output}\nWrong, try again"
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": ""
    }