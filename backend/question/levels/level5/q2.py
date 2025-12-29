from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()


class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ===============================
# LEVEL 5 - QUESTION 2
# ===============================

@router.get("/level/5/question/2")
def get_question():
    return {
        "question": (
            "Use a comparison operator ( >= or <= ) to check if the player has "
            "enough coins to buy an item. Print the result."
        ),
        "code": "coins = 10\nitem_cost = 10\n"
    }


@router.post("/level/5/question/2")
def post_user_code(request: UserCodeRequest):
    """
    Correct student solution (example):

    coins = 10
    item_cost = 10

    print(coins >= item_cost)

    Expected output:
    True
    """

    user_code = request.user_code

    if not user_code.strip().startswith("coins = 10"):
        return {
            "status": "error",
            "output": "You must start with the provided code.",
            "is_correct": False,
            "explanation": "Do not modify the initial variables."
        }

    comparison_pattern = re.search(
        r'(coins\s*>=\s*item_cost)|(item_cost\s*<=\s*coins)|'
        r'(coins\s*<=\s*item_cost)|(item_cost\s*>=\s*coins)',
        user_code
    )

    if not comparison_pattern:
        return {
            "status": "error",
            "output": "You must use >= or <= to compare the values.",
            "is_correct": False,
            "explanation": "Example: print(coins >= item_cost)"
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
            "[b]>= and <= Operators[/b]\n\n"
            "These operators compare values and allow equality."
        )
    }
