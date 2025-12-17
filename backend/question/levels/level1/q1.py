from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/1/question/1")
def get_question():
    return {"question": "Output Hello world by typing print('hello world')", "code" : ""}

@router.post("/level/1/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[color=green][b]Correct![/b][/color]\n\n"
        "[b]print()[/b] is a built-in Python function that shows text or values on the screen.\n\n"
        "When you write:\n"
        "[color=#CCCCCC]print('Hello')[/color]\n"
        "Python displays:\n"
        "[color=#CCCCCC]Hello[/color]\n\n"
        "You can use [b]print()[/b] to show messages, debug values, or give feedback to the player.\n"
        "anything inside the parenthesis () will be outputted to the screen\n"
        "A double quotation means its a string of text\n"
    )
    
    output = execute_user_code(request.user_code).strip()
    expected_answer = "hello world"
    is_correct = output.lower() == expected_answer.lower()
    
    message = (
        f"{expected_answer}\nCorrect! The print() function lets you output text or values to the screen."
        if is_correct
        else f"{output}\nWrong, try again"
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }