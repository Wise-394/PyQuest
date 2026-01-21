from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()


# ==============================
# Request Model
# ==============================
class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ==============================
# GET QUESTION
# ==============================
@router.get("/level/11/question/1")
def get_question():
    return {
        "question": (
            "INVENTORY UPGRADE\n"
            "Your sword broke during battle!\n"
            "Upgrade your weapon to continue.\n"
            "Rules:\n"
            "- Inventory starts as ['sword', 'shield', 'potion']\n"
            "- Replace 'sword' with 'magic sword'\n"
            "- Print the updated inventory\n"
        ),
        "code": "inventory = ['sword', 'shield', 'potion']"
    }


# ==============================
# POST USER CODE
# ==============================
@router.post("/level/11/question/1")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]Game Concept: Inventory System[/b]\n\n"

        "In many games, the items a player carries are stored in something called an "
        "inventory. In Python, we can use a [b]list[/b] to represent this inventory.\n\n"

        "Each item in the list takes up a position called an [b]index[/b]. "
        "Indexes always start at 0.\n\n"

        "[b]Inventory example:[/b]\n"
        "[color=red]inventory = ['sword', 'shield', 'potion'][/color]\n\n"

        "Here:\n"
        "• 'sword' is at index 0\n"
        "• 'shield' is at index 1\n"
        "• 'potion' is at index 2\n\n"

        "[b]Upgrading an item:[/b]\n"
        "When a weapon breaks or is upgraded, we replace it in the list.\n"
        "To upgrade the sword, we change the value at index 0:\n\n"
        "[color=red]inventory[0] = 'magic sword'[/color]\n\n"

        "This updates the inventory without creating a new list.\n\n"

        "[b]Why this matters in games:[/b]\n"
        "• Weapons can be upgraded during gameplay\n"
        "• Items can change as the player progresses\n"
        "• The game always knows what the player is carrying\n\n"

        "[color=yellow]Key idea:[/color]\n"
        "Lists are [b]mutable[/b], which means you can change their contents after "
        "they are created. This is why lists are perfect for inventories."
    )


    # --------------------------------------------------
    # Run user code
    # --------------------------------------------------
    try:
        user_output = execute_user_code(request.user_code).strip()
    except Exception as e:
        user_output = f"Error: {str(e)}"

    # --------------------------------------------------
    # Validation: inventory list exists
    # --------------------------------------------------
    if "inventory" not in request.user_code:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Inventory list not found.",
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Validation: upgrade applied
    # --------------------------------------------------
    if "magic sword" not in request.user_code:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Weapon upgrade missing.",
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Validation: inventory printed
    # --------------------------------------------------
    if "print" not in request.user_code.lower():
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ You must print the inventory.",
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Final output validation
    # --------------------------------------------------
    expected_output = "['magic sword', 'shield', 'potion']"

    if user_output != expected_output:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Inventory state is incorrect.",
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # WIN STATE 🎉
    # --------------------------------------------------
    return {
        "status": "success",
        "output": f"{user_output}\n\n🏆 VICTORY! Weapon upgraded successfully.",
        "is_correct": True,
        "explanation": explanation
    }


# =====================================================
# ✅ CORRECT ANSWER (DOCUMENTATION ONLY)
# =====================================================
# inventory = ['sword', 'shield', 'potion']
# inventory[0] = 'magic sword'
# print(inventory)
