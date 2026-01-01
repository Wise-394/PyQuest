from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()


class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ===============================
# LEVEL 6 - LOGICAL OPERATORS
# QUESTION 1 (AND)
# ===============================

@router.get("/level/6/question/1")
def get_question():
    return {
        "question": (
            "The player can enter the dungeon ONLY IF they have a key and a torch.\n"
            "Use the logical operator 'and' to check this and print the result."
        ),
        "code": "has_key = True\nhas_torch = True\n"
    }


@router.post("/level/6/question/1")
def post_user_code(request: UserCodeRequest):
    """
    Correct solution example:

    has_key = True
    has_torch = True

    print(has_key and has_torch)

    Expected output:
    True
    """

    user_code = request.user_code.strip()

    # 1️⃣ Ensure user does not modify the initial variables
    if not user_code.startswith("has_key = True"):
        return {
            "status": "error",
            "output": "You must start with the provided code.",
            "is_correct": False,
            "explanation": "Do not modify the initial variables."
        }

    # 2️⃣ Ensure 'and' is used somewhere in the code
    if "and" not in user_code:
        return {
            "status": "error",
            "output": "You must use the and operator.",
            "is_correct": False,
            "explanation": "Example: print(has_key and has_torch)"
        }

    # 3️⃣ Ensure both variables appear (order-independent)
    if not (re.search(r'\bhas_key\b', user_code) and re.search(r'\bhas_torch\b', user_code)):
        return {
            "status": "error",
            "output": "Both has_key and has_torch must be used.",
            "is_correct": False,
            "explanation": "Use both variables in one logical expression."
        }

    # 4️⃣ Execute the user code
    output = execute_user_code(user_code).strip()

    # 5️⃣ Validate output is True or False
    if output.lower() not in ("true", "false"):
        return {
            "status": "error",
            "output": f"{output}\nOutput must be True or False.",
            "is_correct": False,
            "explanation": ""
        }

    # ✅ Success
    return {
        "status": "success",
        "output": f"{output}\nDungeon access checked!",
        "is_correct": True,
        "explanation": (
            "[b]and Operator (and)[/b]\n\n"
            "The `and` operator is used to combine TWO or more conditions.\n\n"
            "It will return True ONLY if ALL conditions are True.\n"
            "If even ONE condition is False, the result becomes False.\n\n"
            "In this example:\n"
            "- has_key = True\n"
            "- has_torch = True\n\n"
            "Since the player has BOTH the key and the torch, the expression:\n"
            "`has_key and has_torch`\n"
            "evaluates to True.\n\n"
            "[b]Think of it like real life:[/b]\n"
            "You can enter a dungeon only if you have a key AND a torch.\n"
            "Missing even one means you cannot enter.\n\n"
            "[b]Quick Logic Check:[/b]\n"
            "True and True   → True\n"
            "True and False  → False\n"
            "False and True  → False\n"
            "False and False → False"
        )
    }
