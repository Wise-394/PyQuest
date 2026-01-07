from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/8/question/3")
def get_question():
    return {
        "question": "Write a program for a bank loan approval. Approve the loan (print 'Approved') if: credit score is 700 or above AND income is 30000 or above, OR if they have a cosigner AND income is at least 20000. Otherwise print 'Denied'.",
        "code": "credit_score = 720\nincome = 35000\nhas_cosigner = False"
    }

@router.post("/level/8/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]Complex Conditional Logic[/b]\n\n"

        "[b]Multiple pathways to success:[/b]\n"
        "Sometimes there are different ways to meet requirements:\n"
        "• Path 1: Good credit AND good income\n"
        "• Path 2: Cosigner AND minimum income\n\n"

        "[b]Using OR between AND groups:[/b]\n"
        "[color=red]if (credit_score >= 700 and income >= 30000) or (has_cosigner and income >= 20000):[/color]\n"
        "[color=red]    print('Approved')[/color]\n"
        "[color=red]else:[/color]\n"
        "[color=red]    print('Denied')[/color]\n\n"

        "[b]Reading complex conditions:[/b]\n"
        "Break it into parts:\n"
        "1. (credit_score >= 700 and income >= 30000) ← First way to qualify\n"
        "2. OR\n"
        "3. (has_cosigner and income >= 20000) ← Second way to qualify\n\n"

        "[b]Why use parentheses:[/b]\n"
        "Parentheses group conditions that belong together:\n"
        "• Without them: Python might evaluate in wrong order\n"
        "• With them: Clear which conditions are paired\n\n"

        "[b]Testing strategy:[/b]\n"
        "Test each pathway separately:\n"
        "• High credit + high income = approved\n"
        "• Cosigner + medium income = approved\n"
        "• Neither pathway met = denied\n\n"

        "[color=yellow]Pro tip:[/color]\n"
        "For very complex logic, consider breaking it into variables:\n"
        "[color=red]path1 = credit_score >= 700 and income >= 30000[/color]\n"
        "[color=red]path2 = has_cosigner and income >= 20000[/color]\n"
        "[color=red]if path1 or path2:[/color]\n"
        "[color=red]    print('Approved')[/color]"
    )

    # Test with multiple cases covering both pathways
    test_cases = [
        (720, 35000, False, "Approved"),  # Path 1: good credit + income
        (750, 40000, False, "Approved"),  # Path 1: excellent credit
        (650, 25000, True, "Approved"),   # Path 2: cosigner + income
        (600, 20000, True, "Approved"),   # Path 2: exactly 20000
        (650, 15000, True, "Denied"),     # Has cosigner but income too low
        (680, 35000, False, "Denied"),    # Good income but credit too low
        (720, 25000, False, "Denied"),    # Good credit but income too low
        (600, 15000, False, "Denied"),    # Neither pathway
        (700, 30000, False, "Approved"),  # Path 1: exactly at thresholds
        (700, 30000, True, "Approved"),   # Path 1 (cosigner doesn't hurt)
        (500, 50000, False, "Denied"),    # High income but bad credit, no cosigner
        (800, 20000, False, "Denied")     # Great credit but income too low
    ]
    
    all_correct = True
    failed_case = None
    
    for test_credit, test_income, test_cosigner, expected in test_cases:
        modified_code = re.sub(r'credit_score\s*=\s*\d+', f'credit_score = {test_credit}', request.user_code)
        modified_code = re.sub(r'income\s*=\s*\d+', f'income = {test_income}', modified_code)
        modified_code = re.sub(r'has_cosigner\s*=\s*(True|False)', f'has_cosigner = {test_cosigner}', modified_code)
        output = execute_user_code(modified_code).strip()
        
        if output != expected:
            all_correct = False
            failed_case = (test_credit, test_income, test_cosigner, expected, output)
            break
    
    if all_correct:
        message = "Perfect! You've mastered complex conditions with multiple logical operators and pathways."
        is_correct = True
    else:
        test_credit, test_income, test_cosigner, expected, output = failed_case
        message = f"Wrong. When credit_score={test_credit}, income={test_income}, has_cosigner={test_cosigner}, expected '{expected}' but got '{output}'. Remember: (credit>=700 AND income>=30000) OR (cosigner AND income>=20000)."
        is_correct = False

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }