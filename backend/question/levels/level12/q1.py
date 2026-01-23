from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/12/question/1")
def get_question():
    return {
        "question": (
            "You found 3 items in a treasure chest! Create a tuple called 'inventory' "
            "containing exactly these items in order: 'sword', 'potion', 'shield'\n"
            "Then print each item on a separate line using indexing.\n"
            "Remember: tuples use parentheses () and are indexed starting from 0!"
        ),
        "code": "# Create your inventory tuple here\n"
    }


@router.post("/level/12/question/1")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]🎯 Welcome to Tuples![/b]\n\n"

        "[b]What is a tuple?[/b]\n"
        "A tuple is like a list, but it CANNOT be changed after creation.\n"
        "Perfect for storing items that should stay the same!\n\n"

        "[b]Creating a tuple:[/b]\n"
        "[color=red]inventory = ('sword', 'potion', 'shield')[/color]\n"
        "Use parentheses () with items separated by commas.\n\n"

        "[b]Accessing tuple items:[/b]\n"
        "[color=red]inventory[0][/color]  → 'sword' (first item)\n"
        "[color=red]inventory[1][/color]  → 'potion' (second item)\n"
        "[color=red]inventory[2][/color]  → 'shield' (third item)\n\n"

        "[b]Why use tuples?[/b]\n"
        "• Faster than lists\n"
        "• Protect data from accidental changes\n"
        "• Great for coordinates, RGB colors, or fixed collections\n\n"

        "[b]Tuple vs List:[/b]\n"
        "List: items = ['a', 'b', 'c']  → can change\n"
        "Tuple: items = ('a', 'b', 'c')  → cannot change\n\n"

        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Tuples are perfect for game items that shouldn't change,\n"
        "like quest requirements or character stats!"
    )

    # Run user code
    try:
        user_output = execute_user_code(request.user_code).strip()
    except Exception as e:
        return {
            "status": "success",
            "output": f"Error: {str(e)}",
            "is_correct": False,
            "explanation": explanation
        }

    # Check if tuple is created
    if "inventory" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create a tuple called 'inventory'."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Check if using parentheses (tuple syntax)
    if "(" not in request.user_code or ")" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Tuples use parentheses (). Use: inventory = ('sword', 'potion', 'shield')"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Check if using indexing
    if "inventory[" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You must use indexing to print each item. Example: print(inventory[0])"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Expected output
    expected = "sword\npotion\nshield"

    if user_output != expected:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Output doesn't match! Make sure your tuple contains:\n"
                "'sword', 'potion', 'shield' (in that order)\n"
                "And print each item using indexing: inventory[0], inventory[1], inventory[2]"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Success!
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "✅ Perfect! You've mastered tuple creation and indexing!\n"
            "🎒 Inventory loaded successfully!"
        ),
        "is_correct": True,
        "explanation": explanation
    }
    # Correct answer:
# inventory = ('sword', 'potion', 'shield')
# print(inventory[0])
# print(inventory[1])
# print(inventory[2])