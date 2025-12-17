from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/2/question/3")
def get_question():
    code = ("num1 = 10\n"
    "num2 = 5\n"
    "result = num1 + num2"
    )
    return {"question": "print the result variable", "code": code}

@router.post("/level/2/question/3")
def post_user_code(request: UserCodeRequest):
    output = execute_user_code(request.user_code).strip()
    expected_answer = "15"
    is_correct = output.lower() == expected_answer
    explanation = ("""
This question uses [b]numbers and addition[/b] in Python.

[b]Understanding the Variables[/b]  
The values `10` and `5` are stored in variables using the [b]=[/b] operator.
[code]
num1 = 10
num2 = 5
[/code]
[b]Adding Numbers[/b]  
The `+` operator adds the two numbers and stores the result in another variable.
[code]
result = num1 + num2
[/code]
[b]Printing the Result[/b]  
To display the value stored in `result`, use the [b]print()[/b] function.
[code]
print(result)
[/code]
[b]Key Points:[/b]  
-Variables can store numbers
-Use [b]+[/b] to add values
-Results can be stored in new variables
-Use [b]print()[/b] to show output
""")
    message = (
        f"{output}\nCorrect!"
        if is_correct
        else f"{output}\nWrong, try again"
    )

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }