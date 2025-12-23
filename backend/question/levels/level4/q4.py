from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/4/question/4")
def get_question():
    return {
        "question": "You have 50 points in a game, but you lost a level and need to subtract 15 points as a penalty. Use the minus operator (-) to calculate your remaining points. Print out the result.",
        "code": "points = 50\n"
    }

@router.post("/level/4/question/4")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if the code starts with the required initial code
    if not user_code.strip().startswith("points = 50"):
        return {
            "status": "error",
            "output": "You must start with the provided code: points = 50",
            "is_correct": False,
            "explanation": "Don't modify or remove the initial variable declaration"
        }
    
    # Check if the minus operator is used
    if '-' not in user_code:
        return {
            "status": "error",
            "output": "You must use the minus operator (-) in your solution!",
            "is_correct": False,
            "explanation": "The minus operator (-) is used for subtraction in Python. For example: points - 15"
        }
    
    # Check if user is hardcoding the answer in print statement
    if re.search(r'print\s*\(\s*35\s*\)', user_code):
        return {
            "status": "error",
            "output": "Don't hardcode the answer! You need to calculate the result using subtraction.",
            "is_correct": False,
            "explanation": "Instead of print(35), you should calculate the remaining points by subtracting 15 from points, then print that result."
        }
    
    # Check if the number 15 appears in the code (the penalty amount)
    if '15' not in user_code:
        return {
            "status": "error",
            "output": "You need to subtract 15 points from your total!",
            "is_correct": False,
            "explanation": "The penalty is 15 points, so you should subtract 15 from points."
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
            "explanation": "Remember to use print() to display the result"
        }
    
    # Check if the output is 35 (50 - 15 = 35)
    try:
        printed_value = int(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": ""
        }
    
    if printed_value != 35:
        return {
            "status": "error",
            "output": f"{output}\nExpected output: 35, but got {printed_value}",
            "is_correct": False,
            "explanation": "When you subtract 15 points from 50 points, you should have 35 points remaining. So points - 15 = 35"
        }
    
    explanation = (
        "[b]The Minus Operator (-)[/b] performs subtraction in Python.\n\n"
        "In this example:\n"
        "[color=red]points = 50[/color]\n"
        "[color=red]remaining = points - 15[/color]\n"
        "[color=red]print(remaining)[/color]\n\n"
        "The expression [b]points - 15[/b] subtracts 15 from the current value of points (50).\n\n"
        "Breaking it down:\n"
        "- You start with 50 points\n"
        "- You lose 15 points as a penalty\n"
        "- 50 - 15 = 35 points remaining\n\n"
        "The minus operator can be used in several ways:\n"
        "- [b]Subtraction:[/b] a - b\n"
        "- [b]Negative numbers:[/b] -5\n"
        "- [b]Subtraction assignment:[/b] points -= 15 (shorthand for points = points - 15)\n\n"
        "Subtraction is one of the four basic arithmetic operations in Python, along with:\n"
        "- Addition (+)\n"
        "- Multiplication (*)\n"
        "- Division (/)\n\n"
        "Great job using the minus operator to calculate the remaining points!"
    )
    
    # All checks passed
    message = f"{output}\nCorrect! You successfully calculated that you have 35 points remaining after the 15-point penalty."
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }