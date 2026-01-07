from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/8/question/1")
def get_question():
    return {
        "question": "Write a program for a movie theater. A person can watch an R-rated movie if they are 17 or older OR if they are 13 or older AND have parental permission. Print 'Allowed' if they can watch, otherwise print 'Not allowed'.",
        "code": "age = 15\nhas_permission = True"
    }

@router.post("/level/8/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]if/elif/else statements[/b] allow your program to choose between multiple options.\n\n"

        "[b]Basic Structure:[/b]\n"
        "[color=red]if condition1:[/color]\n"
        "[color=red]    # runs if condition1 is True[/color]\n"
        "[color=red]elif condition2:[/color]\n"
        "[color=red]    # runs if condition1 is False but condition2 is True[/color]\n"
        "[color=red]else:[/color]\n"
        "[color=red]    # runs if all conditions above are False[/color]\n\n"

        "[b]Logical Operators:[/b]\n"
        "• [b]and[/b] - Both conditions must be True\n"
        "• [b]or[/b] - At least one condition must be True\n"
        "• [b]not[/b] - Reverses the condition\n\n"

        "[b]Combining OR and AND:[/b]\n"
        "[color=red]if age >= 17 or (age >= 13 and has_permission):[/color]\n"
        "[color=red]    print('Allowed')[/color]\n"
        "[color=red]else:[/color]\n"
        "[color=red]    print('Not allowed')[/color]\n\n"

        "This checks: Is the person 17+ OR (13+ AND has permission)?\n\n"

        "[color=yellow]Important:[/color]\n"
        "• Use parentheses () to group conditions clearly\n"
        "• Python evaluates 'and' before 'or'\n"
        "• Only ONE block of code will run\n"
        "• Test all possible combinations"
    )

    # Test with multiple cases
    test_cases = [
        (15, True, "Allowed"),      # 13+ with permission
        (15, False, "Not allowed"), # 13+ without permission
        (18, False, "Allowed"),     # 17+ (permission doesn't matter)
        (12, True, "Not allowed"),  # Under 13 (even with permission)
        (17, False, "Allowed"),     # Exactly 17
        (13, True, "Allowed"),      # Exactly 13 with permission
        (20, True, "Allowed"),      # Adult with permission
        (10, False, "Not allowed")  # Child without permission
    ]
    
    all_correct = True
    failed_case = None
    
    for test_age, test_permission, expected in test_cases:
        modified_code = re.sub(r'age\s*=\s*\d+', f'age = {test_age}', request.user_code)
        modified_code = re.sub(r'has_permission\s*=\s*(True|False)', f'has_permission = {test_permission}', modified_code)
        output = execute_user_code(modified_code).strip()
        
        if output != expected:
            all_correct = False
            failed_case = (test_age, test_permission, expected, output)
            break
    
    if all_correct:
        message = "Correct! You've successfully combined OR and AND operators to check movie eligibility."
        is_correct = True
    else:
        test_age, test_permission, expected, output = failed_case
        message = f"Wrong. When age = {test_age} and has_permission = {test_permission}, expected '{expected}' but got '{output}'. Remember: 17+ OR (13+ AND has permission)."
        is_correct = False

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }