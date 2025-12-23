from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/4/question/3")
def get_question():
    return {
        "question": "You have 20 slices of pizza and want to distribute them equally among 4 friends. Use the division assignment operator (/=) to divide the slices by the number of friends. Print out the result.",
        "code": "pizza_slices = 20\n"
    }

@router.post("/level/4/question/3")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if the code starts with the required initial code
    if not user_code.strip().startswith("pizza_slices = 20"):
        return {
            "status": "error",
            "output": "You must start with the provided code: pizza_slices = 20",
            "is_correct": False,
            "explanation": "Don't modify or remove the initial variable declaration"
        }
    
    # Check if the /= operator is used
    if '/=' not in user_code:
        return {
            "status": "error",
            "output": "You must use the division assignment operator (/=) in your solution!",
            "is_correct": False,
            "explanation": "The division assignment operator (/=) divides a variable by a value and stores the result back in the variable. For example: pizza_slices /= 4"
        }
    
    # Check if user is hardcoding the answer in print statement
    if re.search(r'print\s*\(\s*5\.?0?\s*\)', user_code):
        return {
            "status": "error",
            "output": "Don't hardcode the answer! You need to use the /= operator on pizza_slices.",
            "is_correct": False,
            "explanation": "Instead of print(5.0), you should divide pizza_slices by 4 using /=, then print pizza_slices."
        }
    
    # Check if the number 4 appears in the code (number of friends)
    if '4' not in user_code:
        return {
            "status": "error",
            "output": "You need to divide the pizza slices among 4 friends!",
            "is_correct": False,
            "explanation": "Use pizza_slices /= 4 to divide among 4 friends."
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
            "explanation": "Remember to use print(pizza_slices) to display the result"
        }
    
    # Check if the output is 5.0 or 5 (20 / 4 = 5)
    try:
        printed_value = float(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": ""
        }
    
    if printed_value != 5.0:
        return {
            "status": "error",
            "output": f"{output}\nExpected output: 5.0, but got {printed_value}",
            "is_correct": False,
            "explanation": "When you divide 20 pizza slices equally among 4 friends, each friend gets 5 slices. So pizza_slices /= 4 should result in 5.0"
        }
    
    explanation = (
        "[b]The Division Assignment Operator (/=)[/b] divides a variable and updates it in one step.\n\n"
        "In this example:\n"
        "[color=red]pizza_slices = 20[/color]\n"
        "[color=red]pizza_slices /= 4[/color]\n"
        "[color=red]print(pizza_slices)[/color]\n\n"
        "The expression [b]pizza_slices /= 4[/b] is a shorthand for [b]pizza_slices = pizza_slices / 4[/b]\n\n"
        "Breaking it down:\n"
        "- Start with 20 pizza slices\n"
        "- Divide by 4 friends: 20 ÷ 4 = 5.0\n"
        "- Store the result back in pizza_slices\n"
        "- Each friend gets 5 slices!\n\n"
        "Assignment operators like [b]/=[/b] are useful shortcuts:\n"
        "- [b]+=[/b] adds and assigns (x += 5)\n"
        "- [b]-=[/b] subtracts and assigns (x -= 3)\n"
        "- [b]*=[/b] multiplies and assigns (x *= 2)\n"
        "- [b]/=[/b] divides and assigns (x /= 4)\n\n"
        "These operators make your code more concise and easier to read!\n\n"
        "Great job using the division assignment operator to distribute the pizza slices!"
    )
    
    # All checks passed
    message = f"{output}\nCorrect! You successfully divided 20 pizza slices among 4 friends. Each friend gets 5.0 slices."
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }