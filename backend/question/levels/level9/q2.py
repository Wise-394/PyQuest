from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/9/question/2")
def get_question():
    return {
        "question": (
            "Write a program that prints all even numbers from 2 to n (inclusive). "
            "Use a for loop with range()."
        ),
        "code": "n = 10"
    }


@router.post("/level/9/question/2")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]For Loops and range()[/b]\n\n"

        "[b]What is a for loop?[/b]\n"
        "A for loop repeats code for each value in a sequence.\n"
        "It is best used when you know how many times the loop should run.\n\n"

        "[b]Basic for loop structure:[/b]\n"
        "[color=red]for variable in sequence:[/color]\n"
        "[color=red]    # code inside the loop[/color]\n\n"

        "[b]Indentation is important![/b]\n"
        "Only indented lines belong to the loop.\n"
        "If a line is not indented, it runs after the loop ends.\n\n"

        "[b]Using range():[/b]\n"
        "[color=red]range(start, stop, step)[/color]\n"
        "• start → first number (included)\n"
        "• stop → last number (not included)\n"
        "• step → how much the number increases each time\n\n"

        "[b]Even numbers example:[/b]\n"
        "[color=red]n = 10[/color]\n"
        "[color=red]for i in range(2, n + 1, 2):[/color]\n"
        "[color=red]    print(i)[/color]\n\n"

        "[b]How this works:[/b]\n"
        "• Starts at 2\n"
        "• Adds 2 each time\n"
        "• Stops when the number is greater than n\n\n"

        "[b]Common beginner mistakes:[/b]\n"
        "• Forgetting to use range()\n"
        "• Using the wrong stop value\n"
        "• Hardcoding numbers instead of looping\n"
        "• Incorrect indentation\n\n"

        "[color=yellow]Key idea:[/color]\n"
        "Let the loop generate the numbers — do not print them manually."
    )

    # --------------------------------------------------
    # Run user code once to capture output
    # --------------------------------------------------
    try:
        user_output = execute_user_code(request.user_code).strip()
    except Exception as e:
        user_output = f"Error: {str(e)}"

    # --------------------------------------------------
    # Must use for loop
    # --------------------------------------------------
    if "for" not in request.user_code.lower():
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You must use a for loop for this exercise."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Must use range()
    # --------------------------------------------------
    if "range(" not in request.user_code.lower():
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Your for loop must use range()."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Prevent hardcoded numbers
    # --------------------------------------------------
    clean_code = request.user_code.replace(" ", "")
    hardcoded_count = sum(
        1 for num in ["2", "4", "6", "8", "10", "12", "14", "16", "18", "20"]
        if f"print({num})" in clean_code
    )

    if hardcoded_count >= 4:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Numbers are hardcoded. Use a loop to generate even numbers."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Test with different values of n
    # --------------------------------------------------
    test_cases = [
        (10, "2\n4\n6\n8\n10"),
        (6, "2\n4\n6"),
        (15, "2\n4\n6\n8\n10\n12\n14"),
        (2, "2"),
        (20, "2\n4\n6\n8\n10\n12\n14\n16\n18\n20"),
        (3, "2"),
        (1, "")
    ]

    for n_value, expected in test_cases:
        modified_code = re.sub(
            r"n\s*=\s*\d+",
            f"n = {n_value}",
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
                    f"❌ Incorrect output when n = {n_value}.\n"
                    "Check your range() values and loop logic."
                ),
                "is_correct": False,
                "explanation": explanation
            }

    # --------------------------------------------------
    # All tests passed
    # --------------------------------------------------
    return {
        "status": "success",
        "output": (
            f"{user_output}\n\n"
            "✅ Great job! Your for loop correctly prints all even numbers."
        ),
        "is_correct": True,
        "explanation": explanation
    }
