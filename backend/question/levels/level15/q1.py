from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/15/question/1")
def get_question():
    return {
        "question": (
            "Create your first function! Write a function called 'greet_player' that:\n"
            "• Takes one parameter: player_name\n"
            "• Prints 'Welcome, [player_name]!'\n\n"
            "Then call the function with the name 'Hero'"
        ),
        "code": ""
    }

@router.post("/level/15/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Welcome to Functions![/b]\n\n"
        "[b]What is a function?[/b]\n"
        "A reusable block of code that performs a specific task.\n"
        "Write once, use many times!\n\n"
        "[b]Creating a function:[/b]\n"
        "[color=red]def function_name(parameter):[/color]\n"
        "[color=red]    # code here[/color]\n"
        "• Use 'def' keyword\n"
        "• Function name followed by parentheses\n"
        "• Don't forget the colon!\n"
        "• Indent the code inside\n\n"
        "[b]Calling a function:[/b]\n"
        "[color=red]function_name(value)[/color]\n"
        "Use the function name with parentheses and pass a value.\n\n"
        "[b]Parameters:[/b]\n"
        "Variables that receive values when the function is called.\n"
        "[color=red]def greet(name):[/color] ← 'name' is the parameter\n"
        "[color=red]greet('Alice')[/color] ← 'Alice' is the argument\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Functions help you avoid repeating code!\n"
        "Instead of writing greeting code 10 times,\n"
        "write it once and call it 10 times!"
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
    
    if "def greet_player" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to define a function called 'greet_player'.\n"
                "Use: def greet_player(player_name):"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "player_name" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Your function needs a parameter called 'player_name'."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "greet_player(" not in request.user_code.replace(" ", ""):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Don't forget to call your function!\n"
                "Use: greet_player('Hero')"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "Welcome, Hero!" in user_output or "Welcome,Hero!" in user_output:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Excellent! You created and called your first function!\n"
                "⚔️ The Hero has been greeted!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure your function prints 'Welcome, [player_name]!' correctly."
        ),
        "is_correct": False,
        "explanation": explanation
    }

# Correct answer:
# def greet_player(player_name):
#     print(f"Welcome, {player_name}!")
# 
# greet_player('Hero')