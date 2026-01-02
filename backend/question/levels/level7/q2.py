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
        "[b]if-elif-else[/b] chains let you check multiple conditions in order.\n\n"
        "Syntax:\n"
        "[color=red]if condition1:[/color]\n"
        "[color=red]    # runs if condition1 is True[/color]\n"
        "[color=red]elif condition2:[/color]\n"
        "[color=red]    # runs if condition1 is False and condition2 is True[/color]\n"
        "[color=red]else:[/color]\n"
        "[color=red]    # runs if all conditions are False[/color]\n\n"
        "Python checks conditions from top to bottom and stops at the first True condition.\n"
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