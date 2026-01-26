from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/15/question/3")
def get_question():
    return {
        "question": (
            "Create a function called 'is_strong_enough' that:\n"
            "• Takes two parameters: player_level and boss_level\n"
            "• Returns True if player_level is greater than or equal to boss_level\n"
            "• Returns False otherwise\n\n"
            "Test it by calling is_strong_enough(10, 8) and print the result"
        ),
        "code": ""
    }

@router.post("/level/15/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Functions with Conditionals![/b]\n\n"
        "[b]Combining functions and if statements:[/b]\n"
        "Functions can use if/else to make decisions\n"
        "and return different values based on conditions!\n\n"
        "[b]Example structure:[/b]\n"
        "[color=red]def is_old_enough(age):[/color]\n"
        "[color=red]    if age >= 18:[/color]\n"
        "[color=red]        return True[/color]\n"
        "[color=red]    else:[/color]\n"
        "[color=red]        return False[/color]\n\n"
        "[b]Shorter version:[/b]\n"
        "[color=red]def is_old_enough(age):[/color]\n"
        "[color=red]    return age >= 18[/color]\n"
        "Comparisons (>=, >, <, <=, ==) already return True/False!\n\n"
        "[b]Returning booleans:[/b]\n"
        "Functions can return True or False to answer yes/no questions.\n"
        "Perfect for checking game conditions!\n\n"
        "[b]Using the result:[/b]\n"
        "[color=red]can_fight = is_strong_enough(10, 8)[/color]\n"
        "[color=red]if can_fight:[/color]\n"
        "[color=red]    print('Ready for battle!')[/color]\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Boolean functions are great for:\n"
        "• Checking if player can enter areas\n"
        "• Validating if player has enough resources\n"
        "• Determining battle outcomes"
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
    
    if "def is_strong_enough" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to define a function called 'is_strong_enough'."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Your function needs to return True or False!\n"
                "Use: return player_level >= boss_level"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check for two parameters
    if "player_level" not in request.user_code or "boss_level" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Your function needs two parameters: player_level and boss_level."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "is_strong_enough(" not in request.user_code.replace(" ", ""):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Don't forget to call your function!\n"
                "Use: is_strong_enough(10, 8)"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check if output shows True (player level 10 >= boss level 8)
    if "True" in user_output:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Awesome! Your function correctly checks if the player is strong enough!\n"
                "⚔️ Player level 10 vs Boss level 8 = Ready for battle!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure your function returns True when player_level >= boss_level.\n"
            "For is_strong_enough(10, 8), it should return True!"
        ),
        "is_correct": False,
        "explanation": explanation
    }

# Correct answer:
# def is_strong_enough(player_level, boss_level):
#     return player_level >= boss_level
# 
# result = is_strong_enough(10, 8)
# print(result)
#
# Alternative correct answer:
# def is_strong_enough(player_level, boss_level):
#     if player_level >= boss_level:
#         return True
#     else:
#         return False
# 
# print(is_strong_enough(10, 8))