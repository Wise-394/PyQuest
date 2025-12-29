from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()


class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ===============================
# LEVEL 5 - QUESTION 3
# ===============================

@router.get("/level/5/question/3")
def get_question():
    return {
        "question": (
            "Use a comparison operator ( == or != ) to check if the password "
            "matches the correct password. Print the result."
        ),
        "code": "password = 1234\ncorrect_password = 1234\n"
    }


@router.post("/level/5/question/3")
def post_user_code(request: UserCodeRequest):
    """
    Correct student solution (example):

    password = 1234
    correct_password = 1234

    print(password == correct_password)

    Expected output:
    True
    """

    user_code = request.user_code

    if not user_code.strip().startswith("password = 1234"):
        return {
            "status": "error",
            "output": "You must start with the provided code.",
            "is_correct": False,
            "explanation": "Do not modify the initial variables."
        }

    comparison_pattern = re.search(
        r'(password\s*==\s*correct_password)|(password\s*!=\s*correct_password)',
        user_code
    )

    if not comparison_pattern:
        return {
            "status": "error",
            "output": "You must use == or != to compare the passwords.",
            "is_correct": False,
            "explanation": "Example: print(password == correct_password)"
        }

    try:
        output = execute_user_code(user_code).strip()
    except Exception as e:
        return {
            "status": "error",
            "output": f"Error executing code: {str(e)}",
            "is_correct": False,
            "explanation": ""
        }

    if output.lower() not in ("true", "false"):
        return {
            "status": "error",
            "output": f"{output}\nOutput must be True or False.",
            "is_correct": False,
            "explanation": ""
        }

    return {
        "status": "success",
        "output": f"{output}\nCorrect!",
        "is_correct": True,
        "explanation": (
            "[b]== and != Operators[/b]\n\n"
            "== checks equality, != checks inequality."
        )
    }
