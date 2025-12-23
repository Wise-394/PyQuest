from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re
router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/4/question/1")
def get_question():
    return {"question": "how can u increase the value of the coin variable by 1 using the + operator. Print the output to the console", "code" : "coin = 10 \n"}

@router.post("/level/4/question/1")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if the code starts with the required initial code
    if not user_code.strip().startswith("coin = 10"):
        return {
            "status": "error",
            "output": "You must start with the provided code: coin = 10",
            "is_correct": False,
            "explanation": "Don't modify or remove the initial variable declaration"
        }
    
    # Check if the + operator is used (not just +=)
    # Look for patterns like: coin = coin + 1 or coin += 1
    increment_pattern = re.search(r'\bcoin\s*=\s*coin\s*\+\s*1\b|\bcoin\s*\+=\s*1\b', user_code)
    
    if not increment_pattern:
        return {
            "status": "error",
            "output": "You need to increment the coin variable by 1 using the + operator",
            "is_correct": False,
            "explanation": "Use either 'coin = coin + 1' or 'coin += 1' to increase the value"
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
            "output": "No output detected. Did you print the coin variable?",
            "is_correct": False,
            "explanation": "Remember to use print(coin) to display the result"
        }
    
    # Check if the output is 11 (10 + 1)
    try:
        printed_value = int(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": ""
        }
    
    if printed_value != 11:
        return {
            "status": "error",
            "output": f"{output}\nExpected output: 11, but got {printed_value}",
            "is_correct": False,
            "explanation": "You should increase coin by 1 (from 10 to 11)"
        }
    
    explanation = (
        "[b]Incrementing Variables[/b] means increasing their value.\n\n"
        "In this example:\n"
        "[color=red]coin = 10[/color]\n"
        "[color=red]coin = coin + 1[/color]\n\n"
        "The expression [b]coin + 1[/b] takes the current value of coin (10), adds 1, and stores the result (11) back into coin.\n\n"
        "You can also use the shorthand:\n"
        "[color=red]coin += 1[/color]\n"
        "This does the same thing - it adds 1 to the current value of coin.\n\n"
        "Both [b]coin = coin + 1[/b] and [b]coin += 1[/b] are common ways to increment a variable.\n\n"
        "The [b]+ operator[/b] is used for addition in Python, and when combined with assignment (=), "
        "it allows you to update variables based on their current values.\n\n"
        "You correctly incremented the coin variable and printed the new value!"
    )
    
    # All checks passed
    message = f"{output}\nCorrect! You successfully increased the coin value from 10 to 11"
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }