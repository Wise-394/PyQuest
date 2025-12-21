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
            "explanation": "There was an error running your code"
        }
    
    # Check if output exists
    if not output:
        return {
            "status": "error",
            "output": "No output detected",
            "is_correct": False,
            "explanation": "Make sure to print the 'even' variable to the console"
        }
    
    # Check if the output matches the even value
    try:
        printed_value = int(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": "The output should be the value of the 'even' variable"
        }
    
    # Check if the printed value matches the 'even' variable value
    if printed_value != even_value:
        return {
            "status": "error",
            "output": f"{output}\nYou printed {printed_value}, but the 'even' variable has value {even_value}",
            "is_correct": False,
            "explanation": "Make sure to print the 'even' variable itself (e.g., print(even))"
        }
    
    # All checks passed
    message = f"{output}\nCorrect! {even_value} is an even number and was properly printed"
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": ""
    }