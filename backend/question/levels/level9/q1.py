from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


@router.get("/level/9/question/1")
def get_question():
    return {
        "question": (
            "Write a countdown program. Start from 5 and print each number "
            "down to 1, then print 'Blast off!'. Use a while loop."
        ),
        "code": "count = 5"
    }


@router.post("/level/9/question/1")
def post_user_code(request: UserCodeRequest):

    explanation = (
        "[b]Introduction to While Loops[/b]\n\n"

        "[b]What is a while loop?[/b]\n"
        "A while loop lets your program repeat actions as long as a condition is True.\n"
        "It is useful when you don’t know in advance how many times something should repeat.\n\n"

        "[b]Basic structure of a while loop:[/b]\n"
        "[color=red]while condition:[/color]\n"
        "[color=red]    # code inside the loop[/color]\n"
        "[color=red]    # update the variable[/color]\n\n"

        "[b]Important rules to remember:[/b]\n"
        "• The condition is checked BEFORE each loop runs\n"
        "• If the condition becomes False, the loop stops\n"
        "• Code inside the loop must be indented\n\n"

        "[b]Why indentation matters:[/b]\n"
        "Python uses indentation to know which code belongs to the loop.\n"
        "Only indented lines will repeat.\n\n"

        "[b]Countdown example explained:[/b]\n"
        "[color=red]count = 5[/color]  → starting value\n"
        "[color=red]while count >= 1:[/color]  → loop condition\n"
        "[color=red]    print(count)[/color]  → show current number\n"
        "[color=red]    count = count - 1[/color]  → move toward stopping\n"
        "[color=red]print('Blast off!')[/color]  → runs after the loop\n\n"

        "[b]Step-by-step execution:[/b]\n"
        "1. count starts at 5\n"
        "2. Condition is checked: count >= 1 → True\n"
        "3. Number is printed\n"
        "4. count decreases by 1\n"
        "5. Steps 2–4 repeat until count becomes 0\n"
        "6. Loop stops and 'Blast off!' is printed\n\n"

        "[b]Common beginner mistakes:[/b]\n"
        "• Forgetting to change the counter → infinite loop\n"
        "• Using the wrong condition\n"
        "• Printing after the loop but indenting it by mistake\n"
        "• Hardcoding numbers instead of using a variable\n\n"

        "[color=yellow]Key idea:[/color]\n"
        "Every while loop needs:\n"
        "1. A starting value\n"
        "2. A condition\n"
        "3. A change that makes the condition False"
    )


    # --------------------------------------------------
    # Run user code once to capture output
    # --------------------------------------------------
    try:
        user_output = execute_user_code(request.user_code).strip()
    except Exception as e:
        user_output = f"Error: {str(e)}"

    # --------------------------------------------------
    # Must use while loop
    # --------------------------------------------------
    if "while" not in request.user_code.lower():
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ You must use a while loop. Do not hardcode the output."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Prevent hardcoded prints
    # --------------------------------------------------
    hardcoded_prints = 0
    clean_code = request.user_code.replace(" ", "")
    for num in ["1", "2", "3", "4", "5"]:
        if (
            f"print({num})" in clean_code or
            f'print("{num}")' in clean_code or
            f"print('{num}')" in clean_code
        ):
            hardcoded_prints += 1

    if hardcoded_prints >= 3:
        return {
            "status": "success",
            "output": (
                f"{user_output}\n\n"
                "❌ Numbers are hardcoded. Use a variable that changes in a while loop."
            ),
            "is_correct": False,
            "explanation": explanation
        }

    # --------------------------------------------------
    # Test with different start values
    # --------------------------------------------------
    test_cases = [
        (5, "5\n4\n3\n2\n1\nBlast off!"),
        (3, "3\n2\n1\nBlast off!"),
        (7, "7\n6\n5\n4\n3\n2\n1\nBlast off!"),
        (1, "1\nBlast off!"),
        (10, "10\n9\n8\n7\n6\n5\n4\n3\n2\n1\nBlast off!")
    ]

    for start_value, expected in test_cases:
        modified_code = re.sub(
            r"count\s*=\s*\d+",
            f"count = {start_value}",
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
                    f"❌ Incorrect countdown when starting at {start_value}.\n"
                    "Check your loop condition, counter update, and that "
                    "'Blast off!' is printed after the loop."
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
            "✅ Excellent! Your while loop counts down correctly."
        ),
        "is_correct": True,
        "explanation": explanation
    }
