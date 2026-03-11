from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import ast

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/3/question/1")
def get_question():
    return {"question": "Create a variable name 'even' with a value of an even number and output it to the console", "code": ""}

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

def get_assigned_value(user_code: str, variable_name: str):
    """Return the last assigned numeric value of a variable, or None if not found."""
    try:
        tree = ast.parse(user_code)
    except SyntaxError:
        return None

    value = None
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == variable_name:
                    if isinstance(node.value, ast.Constant) and isinstance(node.value.value, (int, float)):
                        value = node.value.value
                    elif isinstance(node.value, ast.UnaryOp) and isinstance(node.value.op, ast.USub):
                        if isinstance(node.value.operand, ast.Constant) and isinstance(node.value.operand.value, (int, float)):
                            value = -node.value.operand.value
    return value

@router.post("/level/3/question/1")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code

    # Check variable 'even' is assigned a numeric value
    even_value = get_assigned_value(user_code, "even")
    if even_value is None:
        return {
            "status": "error",
            "output": "Variable 'even' not found or not assigned a number",
            "is_correct": False,
            "explanation": "You need to create a variable named 'even' with a numeric value"
        }

    # Check the assigned value is even
    if int(even_value) % 2 != 0:
        return {
            "status": "error",
            "output": f"Variable 'even' has value {int(even_value)}, which is not an even number",
            "is_correct": False,
            "explanation": "The variable 'even' must be assigned an even number (divisible by 2)"
        }

    # Check that print() uses the variable, not a hardcoded value
    if not uses_variable_in_print(user_code, "even"):
        return {
            "status": "error",
            "output": "You must print the variable `even`, not a hardcoded value",
            "is_correct": False,
            "explanation": ""
        }

    # Execute the code
    try:
        output = execute_user_code(user_code).strip()
    except Exception as e:
        return {
            "status": "error",
            "output": f"Error executing code: {str(e)}",
            "is_correct": False,
            "explanation": ""
        }

    if not output:
        return {
            "status": "error",
            "output": "No output detected",
            "is_correct": False,
            "explanation": ""
        }

    try:
        printed_value = int(output)
    except ValueError:
        return {
            "status": "error",
            "output": f"{output}\nOutput is not a valid number",
            "is_correct": False,
            "explanation": ""
        }

    if printed_value != int(even_value):
        return {
            "status": "error",
            "output": f"{output}\nYou printed {printed_value}, but the 'even' variable has value {int(even_value)}",
            "is_correct": False,
            "explanation": ""
        }

    explanation = (
        "[b]Data Types[/b] tell Python what kind of value a variable is storing.\n\n"
        "In this example:\n"
        "[color=red]even = 4[/color]\n"
        "The value [b]4[/b] is a whole number, so its data type is an [b]integer (int)[/b].\n\n"
        "Integers are used to store whole numbers, both positive and negative, without decimals.\n"
        "Examples of integers are: 1, 10, -3, 42.\n\n"
        "An [b]even number[/b] is an integer that can be divided by 2 with no remainder.\n\n"
        "When you write:\n"
        "[color=red]print(even)[/color]\n"
        "Python reads the value stored in the variable [b]even[/b] and outputs it to the console.\n\n"
        "You correctly used an [b]int[/b] data type, stored it in a variable, and printed it."
    )

    return {
        "status": "success",
        "output": f"{output}\nCorrect! {int(even_value)} is an even number and was properly printed",
        "is_correct": True,
        "explanation": explanation
    }