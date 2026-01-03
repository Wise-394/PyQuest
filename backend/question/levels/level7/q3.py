from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/7/question/3")
def get_question():
    return {
        "question": "Write a Python code that checks if it's a perfect day for outdoor activities. Print 'Perfect day!' if the temperature is between 20 and 30 (inclusive) AND it's not raining. Otherwise, print nothing.",
        "code": "temperature = 25\nis_raining = False"
    }

@router.post("/level/7/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]Logical operators[/b] let you combine [b]multiple conditions[/b] into one decision.\n"
        "They are useful when a single comparison is not enough.\n\n"

        "Think of them like connectors in a sentence:\n"
        "• I will go outside [b]if[/b] it is sunny [b]and[/b] I am free\n"
        "• I will bring an umbrella [b]if[/b] it is raining [b]or[/b] the sky is dark\n\n"

        "[b]Logical Operators:[/b]\n"
        "[b]and[/b]  → All conditions must be True\n"
        "[b]or[/b]   → At least one condition must be True\n"
        "[b]not[/b]  → Reverses True to False, and False to True\n\n"

        "[b]How they work:[/b]\n"
        "• [b]and[/b] fails if even one condition is False\n"
        "• [b]or[/b] succeeds if at least one condition is True\n"
        "• [b]not[/b] flips the result of a condition\n\n"

        "[b]Example:[/b]\n"
        "[color=red]temperature = 25[/color]\n"
        "[color=red]is_raining = False[/color]\n"
        "[color=red]if temperature >= 20 and temperature <= 30 and not is_raining:[/color]\n"
        "[color=red]    print('Perfect day!')[/color]\n\n"

        "This condition is True only when:\n"
        "• The temperature is between 20 and 30\n"
        "• AND it is not raining\n\n"

        "[b]Chained Comparisons:[/b]\n"
        "Python allows you to write cleaner conditions by chaining comparisons.\n"
        "The following two conditions mean the same thing:\n\n"
        "[color=red]if temperature >= 20 and temperature <= 30 and not is_raining:[/color]\n"
        "[color=red]if 20 <= temperature <= 30 and not is_raining:[/color]\n\n"

        "Chained comparisons are easier to read and are commonly used in Python."
    )

    
    # Prepend the given code to user's code
    full_code = "temperature = 25\nis_raining = False\n" + request.user_code
    output = execute_user_code(full_code).strip()
    expected_answer = "Perfect day!"
    is_correct = output == expected_answer
    
    message = (
        f"{output}\nExcellent! You've combined comparison and logical operators in conditional statements."
        if is_correct
        else f"{output}\nWrong. With temperature = 25 and is_raining = False, it should print 'Perfect day!'. Make sure to check: 20 <= temperature <= 30 AND not is_raining."
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }