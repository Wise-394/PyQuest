from fastapi import APIRouter
from pydantic import BaseModel
import io
import sys
import contextlib

router = APIRouter()

# GET route: example question
@router.get("/question/1")
def get_question():
    return {"question": "Print the name of NPC you just talked to!"}

# Request model for user code
class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

# POST route: execute user code and return output
@router.post("/question/1")
def post_user_code(request: UserCodeRequest):
    output_buffer = io.StringIO()
    try:
        with contextlib.redirect_stdout(output_buffer):
            # Execute user code
            exec(request.user_code, {})  # empty globals for safety
        output = output_buffer.getvalue()
    except Exception as e:
        output = f"Error: {str(e)}"
    finally:
        output_buffer.close()

    return {
        "status": "success",
        "output": output,
        "question_id": request.question_id
    }