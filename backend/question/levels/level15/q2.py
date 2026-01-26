from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/15/question/2")
def get_question():
    return {
        "question": (
            "Functions can return values! Create a function called 'calculate_damage' that:\n"
            "• Takes two parameters: base_damage and multiplier\n"
            "• Returns base_damage * multiplier\n\n"
            "Then call it with base_damage=20 and multiplier=3, and print the result"
        ),
        "code": ""
    }

@router.post("/level/15/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Function Return Values![/b]\n\n"
        "[b]What does 'return' do?[/b]\n"
        "The 'return' keyword sends a value back from the function.\n"
        "This lets you use the result in other parts of your code!\n\n"
        "[b]Function with return:[/b]\n"
        "[color=red]def add(a, b):[/color]\n"
        "[color=red]    return a + b[/color]\n\n"
        "[color=red]result = add(5, 3)[/color]\n"
        "[color=red]print(result)[/color]  # prints 8\n\n"
        "[b]Return vs Print:[/b]\n"
        "• print() → shows output to user\n"
        "• return → sends value back to be used in code\n\n"
        "[b]Multiple parameters:[/b]\n"
        "[color=red]def function(param1, param2, param3):[/color]\n"
        "Separate parameters with commas.\n\n"
        "[b]Using returned values:[/b]\n"
        "[color=red]damage = calculate_damage(20, 3)[/color]\n"
        "[color=red]print(damage)[/color]  # Use the returned value\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Return values let you calculate game stats\n"
        "and use them anywhere in your code!\n"
        "Perfect for damage calculations, score tallying, etc."
    )
    
    try:
        user_output = execute_user_code(request.user_code).strip()
    except Exception as e:
        return {
            "status": "success",
            "output": f"Error: {str(e)}",
            "is_correct": False,
            "explanation": explanation
        }
    
    if "def calculate_damage" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to define a function called 'calculate_damage'."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Your function needs to return a value!\n"
                "Use: return base_damage * multiplier"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check for two parameters
    if "base_damage" not in request.user_code or "multiplier" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Your function needs two parameters: base_damage and multiplier."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "calculate_damage(" not in request.user_code.replace(" ", ""):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Don't forget to call your function!\n"
                "Use: calculate_damage(20, 3)"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "60" in user_output:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Perfect! Your function calculated and returned the damage correctly!\n"
                "⚔️ Critical hit: 60 damage dealt!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure your function returns base_damage * multiplier\n"
            "and you print the result of calculate_damage(20, 3)."
        ),
        "is_correct": False,
        "explanation": explanation
    }

# Correct answer:
# def calculate_damage(base_damage, multiplier):
#     return base_damage * multiplier
# 
# result = calculate_damage(20, 3)
# print(result)