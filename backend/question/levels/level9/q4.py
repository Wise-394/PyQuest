from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()


class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ===============================
# LEVEL 9 - QUESTION 4
# WHILE LOOP (BEGINNER FRIENDLY)
# ===============================

@router.get("/level/9/question/4")
def get_question():
    return {
        "question": (
            "Alex is saving money to buy a video game that costs $50.\n"
            "Alex starts with $0 and saves $5 every day.\n"
            "Write a program using a while loop that:\n"
            "- Adds $5 to the savings each day\n"
            "- Prints the total amount saved each day\n"
            "- Stops when the savings reach or go over $50\n"
            "- Make sure the goal is not hardcoded and works with different values rather than 50 only"
        ),
        "code": (
            "goal = 50\n"
            "saved = 0\n"
            "daily_save = 5"
        )
    }


@router.post("/level/9/question/4")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]Using a While Loop[/b]\n\n"
        "A while loop is used when you want something to keep happening until a certain goal is reached.\n"
        "Instead of knowing exactly how many times the loop will run, the program keeps checking a condition.\n\n"
        "Think of it like saving money in real life.\n"
        "You save a small amount every day, and you keep saving until you finally reach your goal.\n\n"
        "In this problem:\n"
        "- `saved` starts at 0 because no money has been saved yet\n"
        "- `daily_save` is the amount added each day\n"
        "- Each time the loop runs, `daily_save` is added to `saved`\n"
        "- After each addition, the program checks if `saved` is still less than the goal\n\n"
        "As long as `saved` is smaller than the goal, the loop keeps running.\n"
        "Once `saved` becomes equal to or greater than the goal, the loop stops automatically.\n\n"
        "It is very important to update the value of `saved` inside the loop.\n"
        "If `saved` is never updated, the condition will always stay true and the loop will never end."
    )

    # Check for while loop
    if "while" not in request.user_code.lower():
        return {
            "status": "success",
            "output": "❌ You must use a while loop for this challenge.",
            "is_correct": False,
            "explanation": explanation
        }

    # Check for print statement
    if "print" not in request.user_code.lower():
        return {
            "status": "success",
            "output": "❌ You need to print the savings amount each day.",
            "is_correct": False,
            "explanation": explanation
        }

    # Test cases: (goal, daily_save)
    test_cases = [
        (50, 5),
        (25, 10),
        (30, 7),
        (18, 6)
    ]

    for goal_val, daily_val in test_cases:
        # Prepare code with test values
        test_code = request.user_code
        test_code = re.sub(r'goal\s*=\s*\d+', f'goal = {goal_val}', test_code)
        test_code = re.sub(r'daily_save\s*=\s*\d+', f'daily_save = {daily_val}', test_code)
        test_code = re.sub(r'saved\s*=\s*\d+', 'saved = 0', test_code)

        # Execute code
        try:
            result = execute_user_code(test_code)
        except Exception as e:
            return {
                "status": "success",
                "output": f"❌ Runtime error: {str(e)}",
                "is_correct": False,
                "explanation": explanation
            }

        # Parse output for numbers
        output_numbers = re.findall(r'\b\d+\b', result)
        
        if not output_numbers:
            return {
                "status": "success",
                "output": (
                    f"{result}\n\n"
                    f"❌ No numbers found in output. Make sure you're printing the saved amount."
                ),
                "is_correct": False,
                "explanation": explanation
            }

        # Convert to integers
        output_numbers = [int(n) for n in output_numbers]

        # Calculate expected progression
        expected_progression = []
        current = 0
        while current < goal_val:
            current += daily_val
            expected_progression.append(current)

        # Check if we have the right number of values
        if len(output_numbers) < len(expected_progression):
            return {
                "status": "success",
                "output": (
                    f"{result}\n\n"
                    f"❌ Not enough values printed.\n"
                    f"Expected {len(expected_progression)} values, but found {len(output_numbers)}.\n"
                    f"Make sure you print the savings amount each iteration."
                ),
                "is_correct": False,
                "explanation": explanation
            }

        # Extract the relevant numbers (last N numbers matching our expected count)
        actual_progression = output_numbers[-len(expected_progression):]

        # Validate the progression
        if actual_progression != expected_progression:
            return {
                "status": "success",
                "output": (
                    f"{result}\n\n"
                    f"❌ Incorrect savings progression.\n"
                    f"Expected: {expected_progression}\n"
                    f"Got: {actual_progression}\n"
                    f"Hint: Add {daily_val} to saved each day until reaching {goal_val}."
                ),
                "is_correct": False,
                "explanation": explanation
            }

        # Check that loop stops at the right point
        if actual_progression[-1] < goal_val:
            return {
                "status": "success",
                "output": (
                    f"{result}\n\n"
                    f"❌ Loop stopped too early.\n"
                    f"Final savings: ${actual_progression[-1]}, but goal is ${goal_val}.\n"
                    f"The loop should continue until savings reach or exceed the goal."
                ),
                "is_correct": False,
                "explanation": explanation
            }

    # All tests passed - get output from original code for success message
    try:
        final_output = execute_user_code(request.user_code)
    except:
        final_output = "Code executed successfully!"

    return {
        "status": "success",
        "output": (
            f"{final_output}\n\n"
            f"✅ Perfect! Your while loop correctly saves money until the goal is reached! 🎮"
        ),
        "is_correct": True,
        "explanation": explanation
    }