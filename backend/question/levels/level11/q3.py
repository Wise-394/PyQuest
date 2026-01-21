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
@router.get("/level/11/question/3")
def get_question():
    return {
        "question": (
            "You defeated an enemy and found gold!\n\n"
            "Rules:\n"
            "- Inventory starts as ['magic sword', 'shield']\n"
            "- Add 'gold' to the inventory\n"
            "- Print the updated inventory\n"
        ),
        "code": "inventory = ['magic sword', 'shield']"
    }


# ==============================
# POST USER CODE
# ==============================
@router.post("/level/11/question/3")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]Concept: Adding an Item to a List[/b]\n"
        "In Python, a list is a collection of values stored in a single variable.\n"
        "Lists can be modified to add new items at the end.\n\n"
        "[b]Inventory structure:[/b]\n"
        "[color=red]inventory = ['magic sword', 'shield'][/color]\n"
        "Each value in the list represents one item in the inventory.\n\n"
        "[b]The append() method:[/b]\n"
        "[color=red]inventory.append('gold')[/color]\n"
        "The append() method adds the specified value to the end of the list.\n"
        "In this case, the string 'gold' is added as a new item.\n"
        "Use append() to add a new value to the end of a list dynamically."
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

    if "gold" not in request.user_code:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Gold was not added.",
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

    expected_output = "['magic sword', 'shield', 'gold']"

    if user_output != expected_output:
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ Inventory is incorrect.",
            "is_correct": False,
            "explanation": explanation
        }

    return {
        "status": "success",
        "output": f"{user_output}\n\n🏆 LOOT COLLECTED!",
        "is_correct": True,
        "explanation": explanation
    }


# =====================================================
# ✅ CORRECT ANSWER (DOCUMENTATION ONLY)
# =====================================================
# inventory = ['magic sword', 'shield']
# inventory.append('gold')
# print(inventory)
