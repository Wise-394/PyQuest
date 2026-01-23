from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/12/question/3")
def get_question():
    return {
        "question": (
            "You have a party of heroes:\n"
            "party = ('Knight', 'Wizard', 'Archer', 'Cleric')\n"
            "Your quest:\n"
            "1. Use len() to find how many heroes are in the party\n"
            "2. Print: 'Party size: [number]'\n"
            "3. Use a for loop to print each hero's name\n"
            "Example output:\n"
            "Party size: 4\n"
            "Knight\n"
            "Wizard\n"
            "Archer\n"
            "Cleric"
        ),
        "code": (
            "party = ('Knight', 'Wizard', 'Archer', 'Cleric')\n"
            "# Count and print your party\n"
        )
    }


@router.post("/level/12/question/3")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]🎯 Tuple Length and Looping![/b]\n\n"

        "[b]Finding tuple length:[/b]\n"
        "[color=red]len(party)[/color]\n"
        "The len() function tells you how many items are in a tuple.\n"
        "Just like with lists and strings!\n\n"

        "[b]Looping through tuples:[/b]\n"
        "[color=red]for hero in party:[/color]\n"
        "[color=red]    print(hero)[/color]\n"
        "You can iterate through tuples just like lists.\n\n"

        "[b]Complete example:[/b]\n"
        "[color=red]party = ('Knight', 'Wizard')[/color]\n"
        "[color=red]size = len(party)[/color]\n"
        "[color=red]print(f'Party size: {size}')[/color]\n"
        "[color=red]for hero in party:[/color]\n"
        "[color=red]    print(hero)[/color]\n\n"

        "[b]Why this matters in games:[/b]\n"
        "• Check if party is full (max 4 heroes?)\n"
        "• Loop through all heroes for attacks\n"
        "• Calculate total party stats\n\n"

        "[b]Common tuple functions:[/b]\n"
        "[color=red]len(party)[/color]  → number of heroes\n"
        "[color=red]'Knight' in party[/color]  → check if hero exists\n"
        "[color=red]party.count('Wizard')[/color]  → count how many wizards\n\n"

        "[color=yellow]⚔️ Simple but powerful![/color]\n"
        "len() and for loops work the same on tuples and lists!"
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

    # Check if using len()
    if "len(" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You need to use len() to count the party members.\n"
                "Example: len(party)"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Check if using for loop
    if "for" not in request.user_code:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You must use a for loop to print each hero.\n"
                "Example: for hero in party:"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Expected output
    expected = (
        "Party size: 4\n"
        "Knight\n"
        "Wizard\n"
        "Archer\n"
        "Cleric"
    )

    if user_output != expected:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Output doesn't match expected format!\n"
                "Make sure:\n"
                "1. First line says 'Party size: 4'\n"
                "2. Then each hero name on its own line\n"
                "3. Use len(party) and a for loop"
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # Test with different party sizes
    test_cases = [
        (
            "party = ('Paladin', 'Ranger')",
            "Party size: 2\nPaladin\nRanger"
        ),
        (
            "party = ('Warrior', 'Mage', 'Rogue', 'Priest', 'Bard')",
            "Party size: 5\nWarrior\nMage\nRogue\nPriest\nBard"
        ),
        (
            "party = ('Hero',)",
            "Party size: 1\nHero"
        ),
    ]

    for setup, expected_test in test_cases:
        # Extract the user's logic (after the party assignment)
        user_logic = "\n".join([
            line for line in request.user_code.split("\n")
            if "party =" not in line
        ])
        
        test_code = setup + "\n" + user_logic

        try:
            output = execute_user_code(test_code).strip()
        except Exception as e:
            output = f"Error: {str(e)}"

        if output != expected_test:
            return {
                "status": "success",
                "output": (
                    f"{output}\n\n"
                    f"❌ Your code doesn't work with different party sizes.\n"
                    "Make sure your solution works for any party tuple!"
                ),
                "is_correct": False,
                "explanation": explanation
            }

    # All tests passed!
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "✅ PARTY READY! Adventure awaits!\n"
            "⚔️ You've mastered len() and looping through tuples!\n"
            "🏆 Level 12 Complete!"
        ),
        "is_correct": True,
        "explanation": explanation
    }


# Correct answer:
# party = ('Knight', 'Wizard', 'Archer', 'Cleric')
# print(f'Party size: {len(party)}')
# for hero in party:
#     print(hero)