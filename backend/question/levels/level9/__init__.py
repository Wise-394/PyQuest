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
        "question": "Write a countdown program. Start from 5 and print each number down to 1, then print 'Blast off!'. Use a while loop.",
        "code": "count = 5"
    }

@router.post("/level/9/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]Introduction to While Loops[/b]\n\n"

        "[b]What is a while loop?[/b]\n"
        "A while loop repeats code as long as a condition is True:\n"
        "• Checks condition before each iteration\n"
        "• Stops when condition becomes False\n"
        "• Perfect for countdowns, waiting, or unknown repetitions\n\n"

        "[b]Basic syntax:[/b]\n"
        "[color=red]while condition:[/color]\n"
        "[color=red]    # code to repeat[/color]\n"
        "[color=red]    # update the condition variable[/color]\n\n"

        "[b]Countdown example:[/b]\n"
        "[color=red]count = 5[/color]\n"
        "[color=red]while count >= 1:[/color]\n"
        "[color=red]    print(count)[/color]\n"
        "[color=red]    count = count - 1[/color]\n"
        "[color=red]print('Blast off!')[/color]\n\n"

        "[b]How it works:[/b]\n"
        "1. Start: count = 5\n"
        "2. Check: Is count >= 1? Yes → print 5, subtract 1\n"
        "3. Check: Is count >= 1? Yes → print 4, subtract 1\n"
        "4. Check: Is count >= 1? Yes → print 3, subtract 1\n"
        "5. Check: Is count >= 1? Yes → print 2, subtract 1\n"
        "6. Check: Is count >= 1? Yes → print 1, subtract 1\n"
        "7. Check: Is count >= 1? No (count=0) → exit loop\n"
        "8. Print 'Blast off!'\n\n"

        "[b]Common mistakes:[/b]\n"
        "• Forgetting to update the counter → infinite loop!\n"
        "• Wrong condition (e.g., count > 0 instead of count >= 1)\n"
        "• Printing 'Blast off!' inside the loop\n\n"

        "[color=yellow]Important:[/color]\n"
        "Always make sure your loop will eventually stop!\n"
        "The condition must become False at some point."
    )

    # First check: Must contain 'while' keyword
    if 'while' not in request.user_code.lower():
        return {
            "status": "success",
            "output": "You must use a while loop for this exercise! Don't try to hardcode the output.",
            "is_correct": False,
            "explanation": explanation
        }
    
    # Second check: Should not have hardcoded print statements for all numbers
    # Count how many print statements with literal numbers 1-5 exist
    hardcoded_prints = 0
    for num in ['1', '2', '3', '4', '5']:
        if f'print({num})' in request.user_code.replace(' ', '') or f'print("{num}")' in request.user_code.replace(' ', '') or f"print('{num}')" in request.user_code.replace(' ', ''):
            hardcoded_prints += 1
    
    if hardcoded_prints >= 3:  # If they hardcoded 3 or more numbers
        return {
            "status": "success",
            "output": "Don't hardcode the numbers! Use a while loop with a variable that changes each iteration.",
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test with different starting values to ensure they're using a loop properly
    test_cases = [
        (5, "5\n4\n3\n2\n1\nBlast off!"),
        (3, "3\n2\n1\nBlast off!"),
        (7, "7\n6\n5\n4\n3\n2\n1\nBlast off!"),
        (1, "1\nBlast off!"),
        (10, "10\n9\n8\n7\n6\n5\n4\n3\n2\n1\nBlast off!")
    ]
    
    all_correct = True
    failed_case = None
    
    for start_value, expected in test_cases:
        # Replace the initial count value
        modified_code = re.sub(r'count\s*=\s*\d+', f'count = {start_value}', request.user_code)
        
        try:
            output = execute_user_code(modified_code).strip()
            
            if output != expected:
                all_correct = False
                failed_case = (start_value, expected, output)
                break
        except Exception as e:
            all_correct = False
            failed_case = (start_value, expected, f"Error: {str(e)}")
            break
    
    if all_correct:
        message = "Excellent! You've created your first while loop. You understand how to repeat code based on a condition!"
        is_correct = True
    else:
        start_value, expected, output = failed_case
        message = f"incorrect!"
        is_correct = False

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }