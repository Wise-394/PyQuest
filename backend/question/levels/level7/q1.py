from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/7/question/1")
def get_question():
    return {
        "question": "Write a Python code that checks if the person's age is legal (18 or older). Print 'Adult' if they are legal, otherwise print nothing.",
        "code": "person_age = 18"
    }

@router.post("/level/7/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]if statements[/b] allow your program to make decisions.\n"
        "They check a condition, and if that condition is [b]True[/b], the code inside the if block runs.\n\n"

        "Think of it like a real-life decision:\n"
        "• If it is raining → bring an umbrella\n"
        "• If your score is high → you win\n\n"

        "[b]Basic Syntax:[/b]\n"
        "[color=red]if condition:[/color]\n"
        "[color=red]    # code runs only when the condition is True[/color]\n\n"

        "[b][color=yellow]VERY IMPORTANT: INDENTATION[/color][/b]\n"
        "Python uses [b]indentation (spaces or tabs at the start of a line)[/b] to know which code belongs inside the if statement.\n"
        "Indentation is NOT optional in Python.\n\n"

        "You can indent using:\n"
        "• [b]Spaces[/b] (recommended — usually 4 spaces)\n"
        "• [b]Tabs[/b]\n\n"

        "[color=yellow]Warning:[/color]\n"
        "Do NOT mix spaces and tabs in the same block of code.\n"
        "Mixing them can cause confusing errors or unexpected behavior.\n\n"

        "Rules for indentation:\n"
        "• All lines in the same block must use the same indentation\n"
        "• Indented code runs only when the if condition is True\n"
        "• Code without indentation runs all the time\n\n"

        "[b]Comparison Operators[/b] (used to create conditions):\n"
        "==  equal to\n"
        "!=  not equal to\n"
        ">   greater than\n"
        "<   less than\n"
        ">=  greater than or equal to\n"
        "<=  less than or equal to\n\n"

        "[b]Example:[/b]\n"
        "[color=red]person_age = 20[/color]\n"
        "[color=red]if person_age >= 18:[/color]\n"
        "[color=red]    print('Adult')[/color]\n\n"

        "The print statement is indented using spaces or a tab, so Python knows it belongs to the if statement.\n"
        "If it is not indented correctly, Python will show an error or behave incorrectly."
    )

    output = execute_user_code(request.user_code).strip()
    expected_answer = "Adult"
    is_correct = output == expected_answer
    
    message = (
        f"{output}\nCorrect! You've used an if statement with a comparison operator to check the condition."
        if is_correct
        else f"{output}\nWrong. Use if person_age >= 18: to check if the age is legal, then print('Adult')"
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }