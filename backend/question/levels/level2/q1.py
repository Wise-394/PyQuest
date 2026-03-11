from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import ast

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/2/question/1")
def get_question():
    code = "variable = 'hello! Im a variable'"
    return {"question": "How do u print the variable?", "code": code}

def uses_variable_in_print(user_code: str, variable_name: str) -> bool:
    """Check that the user's print statement references the variable, not a hardcoded literal."""
    try:
        tree = ast.parse(user_code)
    except SyntaxError:
        return False

    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            func = node.func
            if (isinstance(func, ast.Name) and func.id == "print") or \
               (isinstance(func, ast.Attribute) and func.attr == "print"):
                for arg in node.args:
                    for sub in ast.walk(arg):
                        if isinstance(sub, ast.Name) and sub.id == variable_name:
                            return True
    return False

@router.post("/level/2/question/1")
def post_user_code(request: UserCodeRequest):
    base_code = "variable = 'hello! Im a variable'\n"
    full_code = base_code + request.user_code
    output = execute_user_code(full_code).strip()

    prints_variable = uses_variable_in_print(request.user_code, "variable")

    if not prints_variable:
        return {
            "status": "success",
            "output": f"{output}\nWrong, you must print the variable `variable`, not a hardcoded value",
            "is_correct": False,
            "explanation": ""
        }

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