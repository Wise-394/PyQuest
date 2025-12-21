from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/3/question/1")
def get_question():
    return {"question": "Create a variable name 'even' with a value of an even number and output it to the console", "code" : ""}

@router.post("/level/3/question/1")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if variable 'even' exists in the code
    even_match = re.search(r'\beven\s*=\s*(-?\d+)', user_code)
    if not even_match:
        return {
            "status": "error",
            "output": "Variable 'even' not found or not assigned a number",
            "is_correct": False,
            "explanation": "You need to create a variable named 'even' with a numeric value"
        }
    
    # Get the value assigned to 'even'
    even_value = int(even_match.group(1))
    
    # Check if the assigned value is even
    if even_value % 2 != 0:
        return {
            "status": "error",
            "output": f"Variable 'even' has value {even_value}, which is not an even number",
            "is_correct": False,
            "explanation": "The variable 'even' must be assigned an even number (divisible by 2)"
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
            "output": "No output detected",
            "is_correct": False,
            "explanation": ""
        }
    
    # Check if the output matches the even value
    try:
        printed_value = int(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": ""
        }
    
    # Check if the printed value matches the 'even' variable value
    if printed_value != even_value:
        return {
            "status": "error",
            "output": f"{output}\nYou printed {printed_value}, but the 'even' variable has value {even_value}",
            "is_correct": False,
            "explanation": ""
        }
    
    explanation = (
    "[b]Data Types[/b] tell Python what kind of value a variable is storing.\n\n"
    "In this example:\n"
    "[color=red]even = 4[/color]\n"
    "The value [b]4[/b] is a whole number, so its data type is an [b]integer (int)[/b].\n\n"
    "Integers are used to store whole numbers, both positive and negative, without decimals.\n"
    "Examples of integers are: 1, 10, -3, 42.\n\n"
    "An [b]even number[/b] is an integer that can be divided by 2 with no remainder.\n\n"
    "When you write:\n"
    "[color=red]print(even)[/color]\n"
    "Python reads the value stored in the variable [b]even[/b] and outputs it to the console.\n\n"
    "You correctly used an [b]int[/b] data type, stored it in a variable, and printed it."
)
    # All checks passed
    message = f"{output}\nCorrect! {even_value} is an even number and was properly printed"
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }