from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/13/question/3")
def get_question():
    return {
        "question": (
            "Two players found different items!\n"
            "Create set 'player1' with: 'sword', 'shield', 'potion'\n"
            "Create set 'player2' with: 'potion', 'bow', 'arrow'\n"
            "Combine them using the union operator | or .union() method.\n"
            "Store the result in 'all_items' and print it.\n"
            "This shows ALL unique items from both players!"
        ),
        "code": ""
    }


@router.post("/level/13/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Set Union - Combining Sets![/b]\n\n"

        "[b]Union combines ALL unique items:[/b]\n"
        "[color=red]all_items = player1 | player2[/color]  ← Using | operator\n"
        "[color=red]all_items = player1.union(player2)[/color]  ← Using method\n\n"

        "[b]Example:[/b]\n"
        "player1 = {'sword', 'shield', 'potion'}\n"
        "player2 = {'potion', 'bow', 'arrow'}\n"
        "Result → {'sword', 'shield', 'potion', 'bow', 'arrow'}\n"
        "Note: 'potion' appears only once!\n\n"

        "[b]Two ways to write union:[/b]\n"
        "• set1 | set2 → shorter, cleaner\n"
        "• set1.union(set2) → more readable\n\n"

        "[b]Key Points:[/b]\n"
        "• Combines all items from both sets\n"
        "• Automatically removes duplicates\n"
        "• Original sets remain unchanged\n\n"

        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Use union to merge inventories when players\n"
        "combine items or join forces!"
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

    if "player1" not in request.user_code or "player2" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create both 'player1' and 'player2' sets."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    if "all_items" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to create 'all_items' to store the union result."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    if "|" not in request.user_code and "union" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You must use | or .union() to combine the sets!"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Check for all expected items
    expected_items = ['sword', 'shield', 'potion', 'bow', 'arrow']
    if all(item in user_output for item in expected_items):
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "✅ Perfect! You've combined both inventories!\n"
                "🤝 All unique items from both players collected!"
            ),
            "is_correct": True,
            "explanation": explanation
        }
    
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "❌ Check your sets! Make sure player1 has 'sword', 'shield', 'potion'\n"
            "and player2 has 'potion', 'bow', 'arrow'"
        ),
        "is_correct": False,
        "explanation": explanation
    }
    # Correct answer:
# player1 = {'sword', 'shield', 'potion'}
# player2 = {'potion', 'bow', 'arrow'}
# all_items = player1 | player2
# print(all_items)