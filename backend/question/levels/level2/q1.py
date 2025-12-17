from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/2/question/1")
def get_question():
    code = "variable = 'hello! Im a variable'"
    return {"question": "How do u print the variable?", "code": code}

@router.post("/level/2/question/1")
def post_user_code(request: UserCodeRequest):
    output = execute_user_code(request.user_code).strip()
    expected_answer = "hello! im a variable"
    is_correct = output.lower() == expected_answer
    
    message = (
        f"{output}\nCorrect!"
        if is_correct
        else f"{output}\nWrong, try again"
    )
    
    explanation = ("""
A [b]variable[/b] in Python is used to store data so it can be reused later. It works like a container that holds a value.

[b]Declaring a Variable[/b]  
Variables are created by assigning a value using the [b]=[/b] operator.
[code]
variable = "hello! Im a variable"
[/code]
This stores a string (text inside quotes) in the variable.
[b]Printing a Variable[/b]  
To display the value stored in a variable, use the [b]print()[/b] function.
[code]
print(variable)
[/code]
Passing the variable name (without quotes) prints its value.
[b]Key Points:[/b]  
-Variables store data
-Use [b]=[/b] to assign values
-Strings use quotes
-Use [b]print(variable)[/b] to display output
""")

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": explanation
    }