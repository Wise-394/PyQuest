from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/8/question/2")
def get_question():
    return {
        "question": "Write a program for a gym. Print 'Free access' if age is less than 12 or greater than 65. Print 'Premium member' if age is 12 to 65 AND has_membership is True. Otherwise print 'Buy membership'.",
        "code": "age = 30\nhas_membership = False"
    }

@router.post("/level/8/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]Combining Multiple Conditions[/b]\n\n"

        "[b]When to use OR:[/b]\n"
        "Use OR when ANY condition being true should trigger the action:\n"
        "[color=red]if age < 12 or age > 65:[/color]\n"
        "[color=red]    print('Free access')[/color]\n"
        "Either being young OR being senior gives free access.\n\n"

        "[b]When to use AND:[/b]\n"
        "Use AND when ALL conditions must be true:\n"
        "[color=red]if age >= 12 and age <= 65 and has_membership:[/color]\n"
        "[color=red]    print('Premium member')[/color]\n"
        "Must be in age range AND have membership.\n\n"

        "[b]Full Example:[/b]\n"
        "[color=red]if age < 12 or age > 65:[/color]\n"
        "[color=red]    print('Free access')[/color]\n"
        "[color=red]elif age >= 12 and age <= 65 and has_membership:[/color]\n"
        "[color=red]    print('Premium member')[/color]\n"
        "[color=red]else:[/color]\n"
        "[color=red]    print('Buy membership')[/color]\n\n"

        "[b]Shortcut for ranges:[/b]\n"
        "Instead of: [color=red]age >= 12 and age <= 65[/color]\n"
        "You can write: [color=red]12 <= age <= 65[/color]\n\n"

        "[color=yellow]Key Points:[/color]\n"
        "• Check conditions in order (if → elif → else)\n"
        "• First matching condition wins\n"
        "• Use elif for mutually exclusive conditions\n"
        "• Use else as the final catch-all"
    )

    # Test with multiple cases
    test_cases = [
        (10, False, "Free access"),      # Child
        (10, True, "Free access"),       # Child with membership (still free)
        (70, False, "Free access"),      # Senior
        (30, True, "Premium member"),    # Adult with membership
        (30, False, "Buy membership"),   # Adult without membership
        (12, True, "Premium member"),    # Boundary: 12 with membership
        (65, True, "Premium member"),    # Boundary: 65 with membership
        (12, False, "Buy membership"),   # Boundary: 12 without membership
        (11, False, "Free access"),      # Just under 12
        (66, False, "Free access")       # Just over 65
    ]
    
    all_correct = True
    failed_case = None
    
    for test_age, test_membership, expected in test_cases:
        modified_code = re.sub(r'age\s*=\s*\d+', f'age = {test_age}', request.user_code)
        modified_code = re.sub(r'has_membership\s*=\s*(True|False)', f'has_membership = {test_membership}', modified_code)
        output = execute_user_code(modified_code).strip()
        
        if output != expected:
            all_correct = False
            failed_case = (test_age, test_membership, expected, output)
            break
    
    if all_correct:
        message = "Excellent! You've correctly used if/elif/else with OR and AND operators for gym membership logic."
        is_correct = True
    else:
        test_age, test_membership, expected, output = failed_case
        message = f"Wrong. When age = {test_age} and has_membership = {test_membership}, expected '{expected}' but got '{output}'. Check: under 12 OR over 65 = free, 12-65 with membership = premium, otherwise buy."
        is_correct = False

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }