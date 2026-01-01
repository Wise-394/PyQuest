from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()


class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ===============================
# LEVEL 5 - LOGICAL OPERATORS
# QUESTION 2 (OR)
# ===============================

@router.get("/level/6/question/2")
def get_question():
    return {
        "question": (
            "The player can heal if they have a potion or know a healing spell.\n"
            "Use the logical operator 'or' and print the result."
        ),
        "code": "has_potion = False\nknows_spell = True\n"
    }


@router.post("/level/6/question/2")
def post_user_code(request: UserCodeRequest):
    """
    Correct solution example:

    has_potion = False
    knows_spell = True

    print(has_potion or knows_spell)

    Expected output:
    True
    """

    user_code = request.user_code.strip()

    # 1️⃣ Ensure the initial variables are not modified
    if not user_code.startswith("has_potion = False"):
        return {
            "status": "error",
            "output": "You must start with the provided code.",
            "is_correct": False,
            "explanation": "Do not modify the initial variables."
        }

    # 2️⃣ Ensure 'or' is used somewhere
    if "or" not in user_code:
        return {
            "status": "error",
            "output": "You must use the 'or' operator.",
            "is_correct": False,
            "explanation": "Example: print(has_potion 'or' knows_spell)"
        }

    # 3️⃣ Ensure both variables appear (any order)
    if not (re.search(r'\bhas_potion\b', user_code) and re.search(r'\bknows_spell\b', user_code)):
        return {
            "status": "error",
            "output": "Both has_potion and knows_spell must be used.",
            "is_correct": False,
            "explanation": "Use both variables in one logical expression."
        }

    # 4️⃣ Execute user code
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
        "output": f"{output}\nHealing condition checked!",
        "is_correct": True,
        "explanation": (
            "[b]'or' Operator ('or')[/b]\n\n"
            "The 'or' operator is used to check multiple conditions.\n\n"
            "It will return True if AT LEAST ONE of the conditions is True.\n"
            "Only when ALL conditions are False will the result be False.\n\n"
            "In this example:\n"
            "- has_potion = False\n"
            "- knows_spell = True\n\n"
            "Because the player knows a healing spell, the expression:\n"
            "`has_potion 'or' knows_spell`\n"
            "evaluates to True.\n\n"
            "[b]Think of it like real life:[/b]\n"
            "You can heal if you have a potion 'or' know a healing spell.\n"
            "You don't need both—having just one is enough.\n\n"
            "[b]Quick Logic Check:[/b]\n"
            "True 'or' True   → True\n"
            "True 'or' False  → True\n"
            "False 'or' True  → True\n"
            "False 'or' False → False"
        )
    }
