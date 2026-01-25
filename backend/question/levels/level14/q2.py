from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/14/question/2")
def get_question():
    return {
        "question": (
            "Your inventory needs updating! Create a dictionary called 'inventory' with:\n"
            "'potions' set to 3\n"
            "'arrows' set to 15\n\n"
            "Then change the number of potions to 5\n"
            "Finally, print the entire inventory to see the update!"
        ),
        "code": ""
    }

@router.post("/level/14/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Modifying Dictionary Values![/b]\n\n"
        "[b]Changing values in a dictionary:[/b]\n"
        "[color=red]inventory['potions'] = 5[/color]\n"
        "Just assign a new value to an existing key!\n\n"
        "[b]How it works:[/b]\n"
        "1. inventory = {'potions': 3, 'arrows': 15}\n"
        "2. inventory['potions'] = 5  ← Update potions\n"
        "3. Now: {'potions': 5, 'arrows': 15}\n\n"
        "[b]Why this is useful:[/b]\n"
        "In games, values change constantly:\n"
        "• Use a potion → decrease count\n"
        "• Find treasure → increase gold\n"
        "• Take damage → decrease health\n\n"
        "[b]Dictionary = Mutable:[/b]\n"
        "Unlike tuples, you CAN change dictionary values!\n"
        "This makes them perfect for tracking changing data.\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Dictionaries are great for inventory systems because\n"
        "you can easily update item quantities as players use them!"
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
    
    if "inventory" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create a dictionary called 'inventory'."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check if they updated potions to 5
    if ("inventory['potions'] = 5" not in request.user_code and 
        'inventory["potions"] = 5' not in request.user_code):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Remember to update potions to 5 using inventory['potions'] = 5"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Check if output shows potions as 5 (not 3)
    if ("'potions': 5" in user_output or '"potions": 5' in user_output) and "15" in user_output:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Excellent! You successfully updated the dictionary!\n"
                "🎒 Inventory modified - potions increased from 3 to 5!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure to:\n"
            "1. Create inventory with potions: 3 and arrows: 15\n"
            "2. Update potions to 5\n"
            "3. Print the inventory"
        ),
        "is_correct": False,
        "explanation": explanation
    }

# Correct answer:
# inventory = {'potions': 3, 'arrows': 15}
# inventory['potions'] = 5
# print(inventory)