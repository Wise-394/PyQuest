from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/14/question/1")
def get_question():
    return {
        "question": (
            "You need to track character stats! Create a dictionary called 'hero' with:\n"
            "'health' set to 100\n"
            "'mana' set to 50\n"
            "'level' set to 5\n\n"
            "Then print the hero's health"
        ),
        "code": ""
    }

@router.post("/level/14/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Welcome to Dictionaries![/b]\n\n"
        "[b]What is a dictionary?[/b]\n"
        "A dictionary stores data in KEY:VALUE pairs.\n"
        "Perfect for storing related information!\n\n"
        "[b]Creating a dictionary:[/b]\n"
        "[color=red]hero = {'health': 100, 'mana': 50, 'level': 5}[/color]\n"
        "Use curly braces {} with key:value pairs (notice the colon!)\n\n"
        "[b]Accessing values:[/b]\n"
        "[color=red]hero['health'][/color] → returns 100\n"
        "Use the key name in square brackets.\n\n"
        "[b]Dictionary vs Set:[/b]\n"
        "Set: {'coin', 'gem'} → just items\n"
        "Dict: {'health': 100, 'mana': 50} → items WITH values\n\n"
        "[b]When to use dictionaries:[/b]\n"
        "• Player stats (health, mana, strength)\n"
        "• Inventory with quantities\n"
        "• Any data where items have associated values\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Dictionaries let you organize game data with meaningful names\n"
        "instead of remembering what index 0, 1, 2 means!"
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
    
    if "hero" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create a dictionary called 'hero'."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if ":" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Dictionaries use colons (:) between keys and values.\n"
                "Try: hero = {'health': 100, 'mana': 50, 'level': 5}"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check if they accessed health
    if "hero['health']" not in request.user_code and 'hero["health"]' not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Don't forget to print the health using hero['health']!"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check if output shows 100 (the health value)
    if "100" in user_output:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Perfect! You created a dictionary and accessed a value by its key!\n"
                "⚔️ Hero stats tracked successfully!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure your dictionary has the correct values and print hero['health']!"
        ),
        "is_correct": False,
        "explanation": explanation
    }

# Correct answer:
# hero = {'health': 100, 'mana': 50, 'level': 5}
# print(hero['health'])