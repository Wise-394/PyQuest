from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import ast

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/2/question/2")
def get_question():
    code = "more_than_10 = 0"
    return {"question": "Print the variable with a value more than 10", "code": code}

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

@router.post("/level/2/question/2")
def post_user_code(request: UserCodeRequest):
    output = execute_user_code(request.user_code).strip()

    prints_variable = uses_variable_in_print(request.user_code, "more_than_10")

    if not prints_variable:
        return {
            "status": "success",
            "output": f"{output}\nWrong, you must print the variable `more_than_10`, not a hardcoded value",
            "is_correct": False,
            "explanation": ""
        }

    try:
        value = float(output)
        is_correct = value > 10
        message = (
            f"{output}\nCorrect!"
            if is_correct
            else f"{output}\nWrong, the variable's value must be greater than 10"
        )
    except (ValueError, TypeError):
        is_correct = False
        message = f"{output}\nWrong, print a value greater than 10"

    return {
        "status": "success",
        "output": message,
        "is_correct": is_correct,
        "explanation": ""
    }