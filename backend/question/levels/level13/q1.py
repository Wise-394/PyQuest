from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/13/question/1")
def get_question():
    return {
        "question": (
            "You found duplicate items in your bag! Create a set called 'unique_items' "
            "containing: 'coin', 'coin', 'gem', 'coin', 'gem', 'key'\n"
            "Then print the set to see how it automatically removes duplicates!\n"
            "Remember: sets use curly braces {} and only store unique values!"
        ),
        "code": ""
    }


@router.post("/level/13/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Welcome to Sets![/b]\n\n"

        "[b]What is a set?[/b]\n"
        "A set is a collection that automatically removes duplicates!\n"
        "It only keeps UNIQUE values.\n\n"

        "[b]Creating a set:[/b]\n"
        "[color=red]unique_items = {'coin', 'coin', 'gem', 'coin', 'gem', 'key'}[/color]\n"
        "Use curly braces {} with items separated by commas.\n\n"

        "[b]Automatic duplicate removal:[/b]\n"
        "Even though we added 'coin' 3 times and 'gem' 2 times,\n"
        "the set will only keep ONE of each!\n\n"

        "[b]Key Features:[/b]\n"
        "• Automatically removes duplicates\n"
        "• Unordered (no indexing like lists/tuples)\n"
        "• Very fast for checking if item exists\n"
        "• Items must be immutable (strings, numbers, tuples)\n\n"

        "[b]Set vs List:[/b]\n"
        "List: [1, 1, 2, 2, 3] → keeps all duplicates\n"
        "Set: {1, 1, 2, 2, 3} → becomes {1, 2, 3}\n\n"

        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Use sets to track unique collectibles or\n"
        "remove duplicate enemies from spawn lists!"
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

    if "unique_items" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create a set called 'unique_items'."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    if "{" not in request.user_code or "}" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Sets use curly braces {}. Try: unique_items = {'coin', 'gem', 'key'}"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Check if output contains the three unique items
    if ("coin" in user_output and "gem" in user_output and "key" in user_output 
        and user_output.count("coin") == 1 and user_output.count("gem") == 1):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Perfect! Notice how the set automatically kept only unique items!\n"
                "🎒 Duplicates removed successfully!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure to create a set with the duplicate items and print it!"
        ),
        "is_correct": False,
        "explanation": explanation
    }
    # Correct answer:
# unique_items = {'coin', 'coin', 'gem', 'coin', 'gem', 'key'}
# print(unique_items)