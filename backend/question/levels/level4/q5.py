from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/4/question/5")
def get_question():
    return {
        "question": (
            "Each power-up in a game gives you 4 bonus points. "
            "If you collect 6 power-ups, use the multiplication operator (*) "
            "to calculate your total bonus points. Print out the result."
        ),
        "code": "power_ups = 6\n"
    }


@router.post("/level/4/question/5")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code

    # Check if the code starts with the required initial code
    if not user_code.strip().startswith("power_ups = 6"):
        return {
            "status": "error",
            "output": "You must start with the provided code: power_ups = 6",
            "is_correct": False,
            "explanation": "Don't modify or remove the initial variable declaration"
        }

    # Check if multiplication operator is used
    if '*' not in user_code:
        return {
            "status": "error",
            "output": "You must use the multiplication operator (*) in your solution!",
            "is_correct": False,
            "explanation": "The multiplication operator (*) is used to multiply values in Python."
        }

    # Prevent hardcoding the answer
    if re.search(r'print\s*\(\s*24\s*\)', user_code):
        return {
            "status": "error",
            "output": "Don't hardcode the answer! Calculate it using multiplication.",
            "is_correct": False,
            "explanation": (
                "Instead of print(24), multiply the number of power-ups by 4 "
                "and then print the result."
            )
        }

    # Ensure the multiplier (4 points per power-up) is used
    if '4' not in user_code:
        return {
            "status": "error",
            "output": "Each power-up is worth 4 points!",
            "is_correct": False,
            "explanation": "You need to multiply the number of power-ups by 4."
        }

    # Execute the user code
    try:
        output = execute_user_code(user_code).strip()
    except Exception as e:
        return {
            "status": "error",
            "output": f"Error executing code: {str(e)}",
            "is_correct": False,
            "explanation": ""
        }

    # Check if output exists
    if not output:
        return {
            "status": "error",
            "output": "No output detected. Did you print the result?",
            "is_correct": False,
            "explanation": "Remember to use print() to display the result."
        }

    # Validate numeric output
    try:
        printed_value = int(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": ""
        }

    # Expected result: 6 * 4 = 24
    if printed_value != 24:
        return {
            "status": "error",
            "output": f"{output}\nExpected output: 24, but got {printed_value}",
            "is_correct": False,
            "explanation": (
                "You collected 6 power-ups, and each one gives 4 points. "
                "So 6 * 4 = 24."
            )
        }

    explanation = (
        "[b]The Multiplication Operator (*)[/b] is used to multiply values in Python.\n\n"
        "In this example:\n"
        "[color=red]power_ups = 6[/color]\n"
        "[color=red]total_points = power_ups * 4[/color]\n"
        "[color=red]print(total_points)[/color]\n\n"
        "The expression [b]power_ups * 4[/b] multiplies how many power-ups you collected "
        "by how many points each one gives.\n\n"
        "Breaking it down:\n"
        "- You collected 6 power-ups\n"
        "- Each power-up gives 4 points\n"
        "- 6 × 4 = 24 total bonus points\n\n"
        "Multiplication is one of Python’s four basic arithmetic operations:\n"
        "- Addition (+)\n"
        "- Subtraction (-)\n"
        "- Multiplication (*)\n"
        "- Division (/)\n\n"
        "Excellent work using the multiplication operator!"
    )

    message = (
        f"{output}\n"
        "Correct! You successfully calculated that you earned 24 bonus points."
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }
