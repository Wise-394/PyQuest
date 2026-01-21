from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()


class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ==============================
# GET QUESTION
# ==============================
@router.get("/level/11/question/2")
def get_question():
    return {
        "question": (
            "You drank a potion to recover health.\n"
            "Rules:\n"
            "- Inventory starts as ['magic sword', 'shield', 'potion']\n"
            "- Remove 'potion' from the inventory\n"
            "- Print the updated inventory\n"
        ),
        "code": "inventory = ['magic sword', 'shield', 'potion']"
    }


# ==============================
# POST USER CODE
# ==============================
@router.post("/level/11/question/2")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]Concept: Removing an Item from a List[/b]\n"
        "In Python, a list is a collection of values stored in a single variable.\n"
        "Items inside a list can be added, changed, or removed.\n\n"
        "[b]Inventory structure:[/b]\n"
        "[color=red]inventory = ['magic sword', 'shield', 'potion'][/color]\n"
        "Each value in the list represents one item in the inventory.\n\n"
        "[b]The remove() method:[/b]\n"
        "[color=red]inventory.remove('potion')[/color]\n"
        "The remove() method deletes the first occurrence of the specified value from the list.\n"
        "In this case, the string 'potion' is searched for and removed.\n\n"
        "[b]Important behavior:[/b]\n"
        "• The list is modified directly\n"
        "• The order of remaining items is preserved\n"
        "• If the value does not exist, Python raises an error\n"
        "[color=yellow]Key idea:[/color]\n"
        "Use remove() when you know the exact value you want to delete from a list."
    )



    try:
        user_output = execute_user_code(request.user_code).strip()
    except Exception as e:
        user_output = f"Error: {str(e)}"

    if "inventory" not in request.user_code:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Inventory not found.",
            "is_correct": False,
            "explanation": explanation
        }

    if "potion" not in request.user_code:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Potion was not removed.",
            "is_correct": False,
            "explanation": explanation
        }

    if "print" not in request.user_code.lower():
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ You must print the inventory.",
            "is_correct": False,
            "explanation": explanation
        }

    expected_output = "['magic sword', 'shield']"

    if user_output != expected_output:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Inventory is incorrect.",
            "is_correct": False,
            "explanation": explanation
        }

    return {
        "status": "success",
        "output": f"{user_output}\n\n🏆 POTION USED SUCCESSFULLY!",
        "is_correct": True,
        "explanation": explanation
    }


# =====================================================
# ✅ CORRECT ANSWER (DOCUMENTATION ONLY)
# =====================================================
# inventory = ['magic sword', 'shield', 'potion']
# inventory.remove('potion')
# print(inventory)
