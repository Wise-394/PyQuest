from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/7/question/1")
def get_question():
    return {
        "question": "Write a Python code that checks if the person's age is legal (18 or older). Print 'Adult' if they are legal, otherwise print nothing.",
        "code": "person_age = 18"
    }

@router.post("/level/7/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]if statements[/b] let your code make decisions based on conditions.\n\n"
        "Syntax:\n"
        "[color=red]if condition:[/color]\n"
        "[color=red]    # code to run if True[/color]\n\n"
        "[b]Comparison operators:[/b]\n"
        "== (equal), != (not equal), > (greater), < (less), >= (greater or equal), <= (less or equal)\n\n"
        "Example:\n"
        "[color=red]if person_age >= 18:[/color]\n"
        "[color=red]    print('Adult')[/color]\n"
    )
    
    output = execute_user_code(request.user_code).strip()
    expected_answer = "Adult"
    is_correct = output == expected_answer
    
    message = (
        f"{output}\nCorrect! You've used an if statement with a comparison operator to check the condition."
        if is_correct
        else f"{output}\nWrong. Use if person_age >= 18: to check if the age is legal, then print('Adult')"
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }