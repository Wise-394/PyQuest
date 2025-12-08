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
@router.get("/question/1")
def get_question():
    return {"question": "Print the name of NPC you just talked to!"}

# -----------------------------
# POST route: execute user code
# -----------------------------
@router.post("/question/1")
def post_user_code(request: UserCodeRequest):
    output = execute_user_code(request.user_code)

    if output.lower() == "starfish":
        result = "starfish \nCorrect! It's starfish"
    else:
        result = "Wrong, try again"

    return {
        "status": "success",
        "output": result,
        "question_id": request.question_id
    }
