from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/12/question/2")
def get_question():
    return {
        "question": (
            "The dragon boss spawns at different locations each game.\n"
            "You're given a tuple of coordinates: boss_location = (150, 200, 5)\n"
            "These represent (x, y, floor_level)\n\n"
            "Your mission:\n"
            "1. Unpack the tuple into three variables: x, y, floor\n"
            "2. Print: 'Dragon spotted at X: [x], Y: [y], Floor: [floor]'\n"
            "Hint: You can unpack like this: a, b, c = (1, 2, 3)"
        ),
        "code": "boss_location = (150, 200, 5)\n# Unpack and print the location\n"
    }


@router.post("/level/12/question/2")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]🎯 Tuple Unpacking![/b]\n\n"

        "[b]What is tuple unpacking?[/b]\n"
        "Unpacking lets you assign tuple values to multiple variables at once.\n"
        "It's like opening a gift box and taking out each item!\n\n"

        "[b]Unpacking syntax:[/b]\n"
        "[color=red]x, y, floor = boss_location[/color]\n"
        "This takes each value from the tuple and assigns it to a variable.\n\n"

        "[b]Example:[/b]\n"
        "[color=red]coordinates = (10, 20, 30)[/color]\n"
        "[color=red]a, b, c = coordinates[/color]\n"
        "Now: a = 10, b = 20, c = 30\n\n"

        "[b]Important rules:[/b]\n"
        "• Number of variables must match number of tuple items\n"
        "• Variables are assigned in order (left to right)\n"
        "• Very useful for functions that return multiple values\n\n"

        "[b]Real game example:[/b]\n"
        "[color=red]player_stats = (100, 50, 25)  # health, mana, stamina[/color]\n"
        "[color=red]health, mana, stamina = player_stats[/color]\n"
        "[color=red]print(f'HP: {health}')[/color]\n\n"

        "[b]Why unpacking is powerful:[/b]\n"
        "Instead of writing:\n"
        "[color=red]x = boss_location[0][/color]\n"
        "[color=red]y = boss_location[1][/color]\n"
        "[color=red]floor = boss_location[2][/color]\n\n"
        "You can write:\n"
        "[color=red]x, y, floor = boss_location[/color]\n\n"

        "[color=yellow]🎮 Pro Tip:[/color]\n"
        "Unpacking makes your code cleaner and easier to read!\n"
        "Perfect for coordinates, RGB values, or any grouped data."
    )

    # Test cases with different boss locations
    test_cases = [
        ((150, 200, 5), "Dragon spotted at X: 150, Y: 200, Floor: 5"),
        ((75, 100, 3), "Dragon spotted at X: 75, Y: 100, Floor: 3"),
        ((0, 0, 1), "Dragon spotted at X: 0, Y: 0, Floor: 1"),
        ((999, 888, 10), "Dragon spotted at X: 999, Y: 888, Floor: 10"),
    ]

    # Check if unpacking is used
    if "=" not in request.user_code or "boss_location" not in request.user_code:
        try:
            user_output = execute_user_code(request.user_code).strip()
        except Exception as e:
            user_output = f"Error: {str(e)}"
        
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to unpack the boss_location tuple into variables."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Check if using indexing instead of unpacking
    if "boss_location[0]" in request.user_code or "boss_location[1]" in request.user_code:
        try:
            user_output = execute_user_code(request.user_code).strip()
        except Exception as e:
            user_output = f"Error: {str(e)}"
        
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Don't use indexing! Unpack the tuple like this:\n"
                "x, y, floor = boss_location"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Test with different locations
    for location, expected in test_cases:
        modified_code = re.sub(
            r"boss_location\s*=\s*\([^)]+\)",
            f"boss_location = {location}",
            request.user_code
        )

        try:
            output = execute_user_code(modified_code).strip()
        except Exception as e:
            output = f"Error: {str(e)}"

        if output != expected:
            return {
                "status": "success",
                "output": (
                    f"{output}\n\n"
                    f"❌ Incorrect output for location {location}.\n"
                    "Expected format: 'Dragon spotted at X: [x], Y: [y], Floor: [floor]'\n"
                    "Make sure you're unpacking the tuple correctly!"
                ),
                "is_correct": False,
                "explanation": explanation
            }

    # All tests passed!
    return {
        "status": "success",
        "output": (
            f"{execute_user_code(request.user_code).strip()}\n\n"
            "✅ Excellent! Dragon location acquired!\n"
            "🐉 You've mastered tuple unpacking! Ready for battle!"
        ),
        "is_correct": True,
        "explanation": explanation
    }


# Correct answer:
# boss_location = (150, 200, 5)
# x, y, floor = boss_location
# print(f'Dragon spotted at X: {x}, Y: {y}, Floor: {floor}')