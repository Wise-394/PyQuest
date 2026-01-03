from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/7/question/2")
def get_question():
    return {
        "question": "Write a Python code that gives a grade based on the student's score. Print 'Excellent' if score >= 90, 'Good' if score >= 70, or 'Need Improvement' for anything lower.",
        "code": "student_score = 75"
    }

@router.post("/level/7/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]if-elif-else[/b] chains allow your program to choose between multiple paths.\n"
        "They are used when you need to check [b]more than one condition[/b], one after another.\n\n"

        "Think of it like making choices:\n"
        "• If the score is high → Grade A\n"
        "• Else if the score is average → Grade B\n"
        "• Else → Grade C\n\n"

        "[b]How it works:[/b]\n"
        "Python checks each condition from [b]top to bottom[/b].\n"
        "As soon as it finds a condition that is [b]True[/b], it runs that block of code and [b]skips the rest[/b].\n\n"

        "[b]Syntax:[/b]\n"
        "[color=red]if condition1:[/color]\n"
        "[color=red]    # runs if condition1 is True[/color]\n"
        "[color=red]elif condition2:[/color]\n"
        "[color=red]    # runs if condition1 is False and condition2 is True[/color]\n"
        "[color=red]else:[/color]\n"
        "[color=red]    # runs if all conditions are False[/color]\n\n"

        "[b][color=yellow]IMPORTANT RULES:[/color][/b]\n"
        "• Only [b]one[/b] block will ever run\n"
        "• [b]elif[/b] is short for \"else if\"\n"
        "• The [b]else[/b] block has no condition\n"
        "• Proper [b]indentation (spaces or tabs)[/b] is required for every block\n\n"

        "[b]Example:[/b]\n"
        "[color=red]score = 75[/color]\n"
        "[color=red]if score >= 90:[/color]\n"
        "[color=red]    print('Grade A')[/color]\n"
        "[color=red]elif score >= 75:[/color]\n"
        "[color=red]    print('Grade B')[/color]\n"
        "[color=red]else:[/color]\n"
        "[color=red]    print('Grade C')[/color]\n\n"

        "In this example, Python prints 'Grade B' because the first condition is False,\n"
        "but the second condition is True. The else block is skipped."
    )

    
    # Prepend the given code to user's code
    full_code = "student_score = 75\n" + request.user_code
    output = execute_user_code(full_code).strip()
    expected_answer = "Good"
    is_correct = output == expected_answer
    
    message = (
        f"{output}\nCorrect! You've mastered if-elif-else chains with comparison operators."
        if is_correct
        else f"{output}\nWrong. With student_score = 75, it should print 'Good'. Check your conditions: score >= 90 for Excellent, score >= 70 for Good."
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }