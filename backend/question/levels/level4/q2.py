from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/4/question/2")
def get_question():
    return {
        "question": "You have 17 cookies and you want to pack them into boxes of 5. You want to know how many cookies will be left over.\nUse the modulo operator to find out the left over cookies. Print out the result.",
        "code": "cookies = 17\n"
    }

@router.post("/level/4/question/2")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if the code starts with the required initial code
    if not user_code.strip().startswith("cookies = 17"):
        return {
            "status": "error",
            "output": "You must start with the provided code: cookies = 17",
            "is_correct": False,
            "explanation": "Don't modify or remove the initial variable declaration"
        }
    
    # Check if the modulo operator is used
    if '%' not in user_code:
        return {
            "status": "error",
            "output": "You must use the modulo operator (%) in your solution!",
            "is_correct": False,
            "explanation": "The modulo operator (%) is used to find the remainder after division. For example: 17 % 5 gives you the remainder when 17 is divided by 5."
        }
    
    # Check if user is hardcoding the answer in print statement
    if re.search(r'print\s*\(\s*2\s*\)', user_code):
        return {
            "status": "error",
            "output": "Don't hardcode the answer! You need to calculate the result using the modulo operator.",
            "is_correct": False,
            "explanation": "Instead of print(2), you should calculate the leftover cookies using cookies % 5, then print that result."
        }
    
    # Check if the number 5 appears in the code (box size)
    if '5' not in user_code:
        return {
            "status": "error",
            "output": "You need to pack the cookies into boxes of 5!",
            "is_correct": False,
            "explanation": "Use the modulo operator with 5 to find how many cookies are left over: cookies % 5"
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
    
    # Check if the output is 2 (17 % 5 = 2)
    try:
        printed_value = int(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": ""
        }
    
    if printed_value != 2:
        return {
            "status": "error",
            "output": f"{output}\nExpected output: 2, but got {printed_value}",
            "is_correct": False,
            "explanation": "When you divide 17 cookies into boxes of 5, you get 3 full boxes (15 cookies) with 2 cookies left over. So 17 % 5 = 2"
        }
    
    explanation = (
        "[b]The Modulo Operator (%)[/b] finds the remainder after division.\n\n"
        "In this example:\n"
        "[color=red]cookies = 17[/color]\n"
        "[color=red]leftover = cookies % 5[/color]\n"
        "[color=red]print(leftover)[/color]\n\n"
        "The expression [b]17 % 5[/b] calculates the remainder when 17 is divided by 5.\n\n"
        "Think of it this way:\n"
        "- 17 ÷ 5 = 3 with a remainder of 2\n"
        "- You can make 3 full boxes of 5 cookies (3 × 5 = 15)\n"
        "- That leaves 2 cookies that don't fit in a complete box\n\n"
        "So [b]17 % 5 = 2[/b]\n\n"
        "The modulo operator is very useful for:\n"
        "- Finding remainders\n"
        "- Checking if numbers are even or odd (n % 2)\n"
        "- Cycling through ranges (like wrapping around in a list)\n\n"
        "Great job using the modulo operator to find the leftover cookies!"
    )
    
    # All checks passed
    message = f"{output}\nCorrect! You successfully found that 2 cookies will be left over when packing 17 cookies into boxes of 5."
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }