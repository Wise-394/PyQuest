from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/13/question/2")
def get_question():
    return {
        "question": (
            "Start with an empty set called 'collected' using set() or {}.\n"
            "Then use .add() to collect these items one by one:\n"
            "'crystal', 'ruby', 'crystal', 'emerald'\n"
            "Finally, print the collected set to see the unique items!\n"
            "Notice: even though you added 'crystal' twice, it appears only once!"
        ),
        "code": ""
    }


@router.post("/level/13/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Adding Items to Sets![/b]\n\n"

        "[b]Creating an empty set:[/b]\n"
        "[color=red]collected = set()[/color]  ← Recommended way\n"
        "Note: {} creates an empty dictionary, not a set!\n\n"

        "[b]Adding items with .add():[/b]\n"
        "[color=red]collected.add('crystal')[/color]\n"
        "[color=red]collected.add('ruby')[/color]\n"
        "[color=red]collected.add('crystal')[/color]  ← Duplicate, won't be added!\n\n"

        "[b]What happens:[/b]\n"
        "• First 'crystal' → added ✓\n"
        "• 'ruby' → added ✓\n"
        "• Second 'crystal' → ignored (already exists)\n\n"

        "[b]Important:[/b]\n"
        "• .add() adds ONE item at a time\n"
        "• Duplicates are automatically ignored\n"
        "• No error if you add a duplicate\n\n"

        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Perfect for tracking collected achievements or\n"
        "visited locations without worrying about duplicates!"
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

    if "collected" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create a set called 'collected'."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    if ".add(" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You must use .add() to add items to the set!"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Check if output contains the three unique items
    if ("crystal" in user_output and "ruby" in user_output and "emerald" in user_output):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Excellent! You've collected unique treasures!\n"
                "💎 Notice 'crystal' appears only once despite adding it twice!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Make sure to add all items: 'crystal', 'ruby', 'crystal', 'emerald'"
        ),
        "is_correct": False,
        "explanation": explanation
    }
    # Correct answer:
# collected = set()
# collected.add('crystal')
# collected.add('ruby')
# collected.add('crystal')
# collected.add('emerald')
# print(collected)