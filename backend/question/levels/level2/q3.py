from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import ast

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

@router.post("/level/2/question/3")
def post_user_code(request: UserCodeRequest):
    base_code = "num1 = 10\nnum2 = 5\nresult = num1 + num2\n"
    full_code = base_code + request.user_code
    output = execute_user_code(full_code).strip()

    prints_variable = uses_variable_in_print(request.user_code, "result")

    if not prints_variable:
        return {
            "status": "success",
            "output": f"{output}\nWrong, you must print the variable `result`, not a hardcoded value",
            "is_correct": False,
            "explanation": ""
        }

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