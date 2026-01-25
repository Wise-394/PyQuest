from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/14/question/3")
def get_question():
    return {
        "question": (
            "A new item appeared! Create a dictionary called 'backpack' with:\n"
            "'sword' set to 1\n"
            "'shield' set to 1\n\n"
            "Then add a new item 'map' with value 1\n"
            "Print the backpack to see all three items!"
        ),
        "code": ""
    }

@router.post("/level/14/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Adding New Items to Dictionaries![/b]\n\n"
        "[b]Adding a new key-value pair:[/b]\n"
        "[color=red]backpack['map'] = 1[/color]\n"
        "If the key doesn't exist, it gets added automatically!\n\n"
        "[b]How it works:[/b]\n"
        "1. backpack = {'sword': 1, 'shield': 1}\n"
        "2. backpack['map'] = 1  ← Add new item\n"
        "3. Now: {'sword': 1, 'shield': 1, 'map': 1}\n\n"
        "[b]Update vs Add:[/b]\n"
        "• If key EXISTS → updates the value\n"
        "• If key DOESN'T EXIST → adds new key-value pair\n\n"
        "[b]Real game example:[/b]\n"
        "player_stats = {'health': 100, 'mana': 50}\n"
        "player_stats['experience'] = 0  ← Add new stat\n"
        "player_stats['health'] = 120     ← Update existing stat\n\n"
        "[b]Why this matters:[/b]\n"
        "Games constantly add new data:\n"
        "• Pick up items → add to inventory\n"
        "• Unlock skills → add to abilities\n"
        "• Discover locations → add to map\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Dictionaries grow dynamically! You don't need to know\n"
        "all keys upfront - just add them when needed!"
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
    
    if "backpack" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create a dictionary called 'backpack'."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check if they added map
    if ("backpack['map']" not in request.user_code and 
        'backpack["map"]' not in request.user_code):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Remember to add the map using backpack['map'] = 1"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check if output shows all three items
    has_sword = "'sword'" in user_output or '"sword"' in user_output
    has_shield = "'shield'" in user_output or '"shield"' in user_output
    has_map = "'map'" in user_output or '"map"' in user_output
    
    if has_sword and has_shield and has_map:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Perfect! You added a new item to your dictionary!\n"
                "🗺️ Map added to backpack - ready to explore!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure to:\n"
            "1. Create backpack with sword and shield\n"
            "2. Add map as a new item\n"
            "3. Print the backpack"
        ),
        "is_correct": False,
        "explanation": explanation
    }

# Correct answer:
# backpack = {'sword': 1, 'shield': 1}
# backpack['map'] = 1
# print(backpack)