from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ===============================
# LEVEL 4 - QUESTION 1
# ===============================

@router.get("/level/5/question/1")
def get_question():
    return {
        "question": (
            "Use a comparison operator ( > or < ) to compare the two players' scores "
            "and print the result."
        ),
        "code": "player1_score = 50\nplayer2_score = 55\n"
    }


@router.post("/level/5/question/1")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code

    # Ensure initial variables exist
    if not user_code.strip().startswith("player1_score = 50"):
        return {
            "status": "error",
            "output": "You must start with the provided code.",
            "is_correct": False,
            "explanation": "Do not modify the initial variable declarations."
        }

    # Allow > OR <
    comparison_pattern = re.search(
        r'(player2_score\s*>\s*player1_score)|(player1_score\s*<\s*player2_score)|'
        r'(player1_score\s*>\s*player2_score)|(player2_score\s*<\s*player1_score)',
        user_code
    )

    if not comparison_pattern:
        return {
            "status": "error",
            "output": "You must use either the > or < comparison operator.",
            "is_correct": False,
            "explanation": "Example: print(player2_score > player1_score)"
        }

    # Execute user code
    try:
        output = execute_user_code(user_code).strip()
    except Exception as e:
        return {
            "status": "error",
            "output": f"Error executing code: {str(e)}",
            "is_correct": False,
            "explanation": ""
        }

    if not output:
        return {
            "status": "error",
            "output": "No output detected.",
            "is_correct": False,
            "explanation": "Remember to print the result of the comparison."
        }

    # Normalize output
    output_normalized = output.lower()

    # Valid outputs:
    # player2 > player1  -> True
    # player1 < player2  -> True
    # player1 > player2  -> False
    # player2 < player1  -> False
    if output_normalized not in ("true", "false"):
        return {
            "status": "error",
            "output": f"{output}\nOutput must be True or False.",
            "is_correct": False,
            "explanation": ""
        }

    explanation = (
        "[b]Comparison Operators[/b]\n\n"
        "You can compare numbers using:\n"
        "[b]>[/b] greater than\n"
        "[b]<[/b] less than\n\n"
        "Examples:\n"
        "player2_score > player1_score → True\n"
        "player1_score < player2_score → True\n\n"
        "Comparison expressions always return either [b]True[/b] or [b]False[/b].\n\n"
        "Good job using a comparison operator!"
    )

    return {
        "status": "success",
        "output": f"{output}\nCorrect!",
        "is_correct": True,
        "explanation": explanation
    }
