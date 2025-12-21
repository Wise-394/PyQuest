from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/3/question/3")
def get_question():
    return {"question": "create a variable named 'pi' that holds the value of pi up to 2 decimal digits ", "code" : ""}

@router.post("/level/3/question/3")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if variable 'pi' exists in the code
    pi_match = re.search(r'\bpi\s*=\s*(\d+\.?\d*)', user_code)
    if not pi_match:
        return {
            "status": "error",
            "output": "Variable 'pi' not found or not assigned a numeric value",
            "is_correct": False,
            "explanation": "You need to create a variable named 'pi' with a numeric value"
        }
    
    # Get the value assigned to 'pi'
    pi_value = float(pi_match.group(1))
    
    # Check if the value is 3.14 (pi rounded to 2 decimal places)
    if pi_value != 3.14:
        return {
            "status": "error",
            "output": f"Variable 'pi' has value {pi_value}, but that's not correct. Remember to round pi to 2 decimal places",
            "is_correct": False,
            "explanation": "Think about what the value of pi is when rounded to 2 decimal places"
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
    "[b]Floating-Point Data Type (float)[/b] is used to store numbers that have decimal values.\n\n"
    "In this example:\n"
    "[color=red]pi = 3.14[/color]\n"
    "The value [b]3.14[/b] contains a decimal point, so its data type is a [b]float[/b].\n\n"
    "Floats are commonly used for mathematical and scientific values that require precision.\n"
    "Examples of float values are: 1.5, 2.0, 0.75, 3.14.\n\n"
    "The number [b]pi[/b] is an irrational number, so it is often rounded when stored in a program.\n"
    "Rounding pi to [b]2 decimal places[/b] gives the value [b]3.14[/b].\n\n"
    "You correctly used a [b]float[/b] data type and assigned it to the variable [b]pi[/b]."
)

    # All checks passed
    message = f"Correct! You created the variable 'pi' with the correct value"
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }