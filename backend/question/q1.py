from fastapi import APIRouter
from pydantic import BaseModel
import io
import contextlib

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

#-----------------
# Helper function to execute user code
# -----------------------------
def execute_user_code(code: str) -> str:
    buffer = io.StringIO()
    try:
        with contextlib.redirect_stdout(buffer):
            exec(code, {})
        return buffer.getvalue().strip()
    except Exception as e:
        return f"Error: {str(e)}"
    finally:
        buffer.close()

# -----------------------------
# GET route: example question
# -----------------------------
@router.get("/question/1")
def get_question():
    return {"question": "Output Hello world by typing print('hello world')"}

# -----------------------------
# POST route: execute user code
# -----------------------------
@router.post("/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
    "[color=green][b]Correct![/b][/color]\n\n"
    "[b]print()[/b] is a built-in Python function that shows text or values on the screen.\n\n"
    "When you write:\n"
    "[color=#CCCCCC]print('Hello')[/font][/color]\n"
    "Python displays:\n"
    "[color=#CCCCCC]Hello[/font][/color]\n\n"
    "You can use [b]print()[/b] to show messages, debug values, or give feedback to the player."
)
    output = execute_user_code(request.user_code).strip()
    expected_answer = "hello world"

    is_correct = output.lower() == expected_answer.lower()
    if is_correct:
        message = (
    f"{expected_answer}\nCorrect! The print() function lets you output text or values to the screen.")
    else:
        message = f"{output}\nWrong, try again"


    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }