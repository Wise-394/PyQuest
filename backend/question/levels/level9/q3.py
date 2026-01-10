from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int



@router.get("/level/9/question/3")
def get_question():
    return {
        "question": (
            "Write a program that calculates the sum of all numbers from 1 to n "
            "using a for loop. Store the sum in a variable and print it."
        ),
        "code": "n = 5\ntotal = 0"
    }


@router.post("/level/9/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]Summing Numbers with a For Loop[/b]\n\n"

        "[b]Overview[/b]\n"
        "A for loop can be used to iterate over a sequence of numbers. "
        "By using a loop, you can perform repeated calculations efficiently, "
        "such as calculating the sum of numbers from 1 to n.\n\n"

        "[b]Syntax[/b]\n"
        "[color=red]for variable in range(start, stop):[/color]\n"
        "[color=red]    # code to execute each iteration[/color]\n\n"

        "[b]Example[/b]\n"
        "[color=red]n = 5[/color]  # the number up to which we want the sum\n"
        "[color=red]total = 0[/color]  # initialize the sum\n"
        "[color=red]for i in range(1, n + 1):[/color]\n"
        "[color=red]    total += i[/color]  # add current number to total\n"
        "[color=red]print(total)[/color]  # print the final sum\n\n"

        "[b]Explanation Step by Step[/b]\n"
        "1. Initialize a variable `total` to 0 to store the sum.\n"
        "2. The for loop iterates `i` from 1 up to n (inclusive).\n"
        "3. Inside the loop, add the value of `i` to `total` each time.\n"
        "4. After the loop finishes, print the value of `total`.\n\n"

        "[b]Key Points[/b]\n"
        "• The range function in `range(1, n + 1)` includes the number n.\n"
        "• Indentation is important: only indented code runs inside the loop.\n"
        "• Using a variable like `total` allows accumulation across iterations."
    )


    # --- checks ---
    try:
        user_output = execute_user_code(request.user_code).strip()
    except Exception as e:
        user_output = f"Error: {str(e)}"

    if "for" not in request.user_code.lower():
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ You must use a for loop.",
            "is_correct": False,
            "explanation": explanation
        }

    if "total" not in request.user_code.lower():
        return {
            "status": "success",
            "output": f"{user_output}\n\n❌ You must use a variable to store the sum (e.g., total).",
            "is_correct": False,
            "explanation": explanation
        }

    # Test with different n values
    test_cases = [
        (5, "15"),
        (10, "55"),
        (1, "1"),
        (0, "0"),
        (7, "28")
    ]

    for n_value, expected in test_cases:
        modified_code = re.sub(r"n\s*=\s*\d+", f"n = {n_value}", request.user_code)
        try:
            output = execute_user_code(modified_code).strip()
        except Exception as e:
            output = f"Error: {str(e)}"

        if output != expected:
            return {
                "status": "success",
                "output": (
                    f"{output}\n\n❌ Incorrect output when n = {n_value}. "
                    "Check your loop logic and total calculation."
                ),
                "is_correct": False,
                "explanation": explanation
            }

    return {
        "status": "success",
        "output": f"{user_output}\n\n✅ Great job! Your for loop correctly sums the numbers.",
        "is_correct": True,
        "explanation": explanation
    }
