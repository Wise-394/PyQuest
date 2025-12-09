from fastapi import APIRouter
from pydantic import BaseModel
import io
import contextlib

router = APIRouter()

# -----------------------------
# Request model
# -----------------------------
class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

# -----------------------------
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
@router.get("/question/2")
def get_question():
    return {"question": "Print the name of NPC you just talked to!"}

# -----------------------------
# POST route: execute user code
# -----------------------------
@router.post("/question/2")
def post_user_code(request: UserCodeRequest):
    output = execute_user_code(request.user_code).strip()
    expected_answer = "starfish"

    is_correct = output.lower() == expected_answer
    if is_correct:
        message = f"{expected_answer}\nCorrect! It's {expected_answer}"
    else:
        message = f"{output}\nWrong, try again"


    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct
    }