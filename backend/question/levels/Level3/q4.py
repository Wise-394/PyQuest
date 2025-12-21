from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/3/question/4")
def get_question():
    return {"question": "Make the code correct", "code" : "python_is_awesome = False"}

@router.post("/level/3/question/4")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if variable 'python_is_awesome' exists in the code
    var_match = re.search(r'\bpython_is_awesome\s*=\s*(\w+)', user_code)
    if not var_match:
        return {
            "status": "error",
            "output": "Variable 'python_is_awesome' not found",
            "is_correct": False,
            "explanation": "You need to keep the variable 'python_is_awesome' in your code"
        }
    
    # Get the value assigned to 'python_is_awesome'
    value = var_match.group(1)
    
    # Check if the value is 'True' (correct Python boolean)
    if value != "True":
        return {
            "status": "error",
            "output": f"Variable 'python_is_awesome' has value '{value}'. Remember that Python booleans are capitalized, and Python IS awesome!",
            "is_correct": False,
            "explanation": "Fix the syntax and set the correct value"
        }
    
    # Execute the user code to verify it runs without errors
    try:
        output = execute_user_code(user_code)
    except Exception as e:
        return {
            "status": "error",
            "output": f"Error executing code: {str(e)}",
            "is_correct": False,
            "explanation": ""
        }
    explanation = (
    "[b]Boolean Data Type (bool)[/b] is used to store values that are either true or false.\n\n"
    "In Python, there are only two boolean values:\n"
    "[color=red]True[/color] and [color=red]False[/color]\n\n"
    "Boolean values are [b]case-sensitive[/b], which means they must start with a capital letter.\n"
    "Writing [color=red]true[/color] or [color=red]false[/color] will cause an error.\n\n"
    "In this example:\n"
    "[color=red]python_is_awesome = True[/color]\n"
    "The value [b]True[/b] has the data type [b]bool[/b].\n\n"
    "Booleans are commonly used in conditions, comparisons, and game logic to control program behavior.\n\n"
    "You correctly fixed the code by using the proper [b]boolean[/b] value and syntax."
)
    # All checks passed
    message = f"Correct! You fixed the code. In Python, booleans are capitalized: True and False. And yes, Python IS awesome!"
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }