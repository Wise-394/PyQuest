import ast
from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()


class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int


# ===============================
# LEVEL 5 - LOGICAL OPERATORS
# QUESTION 3 (NOT)
# ===============================

@router.get("/level/6/question/3")
def get_question():
    return {
        "question": (
            "The enemy is defeated if it is not alive.\n"
            "Use the logical operator 'not' directly on `enemy_alive` and print the result."
        ),
        "code": "enemy_alive = False\n"
    }


@router.post("/level/6/question/3")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code.strip()

    # --- FAIL CASE 1: initial variable modified ---
    if not user_code.startswith("enemy_alive = False"):
        return {
            "status": "error",
            "output": "You modified the initial variable `enemy_alive`.",
            "is_correct": False,
            "explanation": "Do not change the value or name of the initial variable."
        }

    # --- Parse the code to check AST for correct 'not' usage ---
    try:
        tree = ast.parse(user_code)
    except SyntaxError as e:
        return {
            "status": "error",
            "output": str(e),
            "is_correct": False,
            "explanation": "Your code contains a syntax error."
        }

    class NotEnemyAliveVisitor(ast.NodeVisitor):
        def __init__(self):
            self.correct_not_used = False
            self.not_used_on_other = False

        def visit_UnaryOp(self, node):
            # Check for 'not enemy_alive'
            if isinstance(node.op, ast.Not):
                if isinstance(node.operand, ast.Name):
                    if node.operand.id == "enemy_alive":
                        self.correct_not_used = True
                    else:
                        self.not_used_on_other = True
            self.generic_visit(node)

    visitor = NotEnemyAliveVisitor()
    visitor.visit(tree)

    # --- FAIL CASE 2: 'not' used on another variable ---
    if visitor.not_used_on_other and not visitor.correct_not_used:
        return {
            "status": "error",
            "output": "You applied 'not' to a variable other than `enemy_alive`.",
            "is_correct": False,
            "explanation": "The 'not' operator must be applied directly to `enemy_alive`, not other variables."
        }

    # --- FAIL CASE 3: 'not' not used at all ---
    if not visitor.correct_not_used:
        return {
            "status": "error",
            "output": "You did not use the 'not' operator on `enemy_alive`.",
            "is_correct": False,
            "explanation": "Example of correct usage: print('not' enemy_alive) or result = 'not' enemy_alive"
        }

    # --- Execute the user code ---
    output = execute_user_code(user_code).strip()

    # --- FAIL CASE 4: Output is not True ---
    if output.lower() != "true":
        return {
            "status": "error",
            "output": output,
            "is_correct": False,
            "explanation": "The expression must evaluate to True because the enemy is not alive."
        }

    # --- Success ---
    return {
        "status": "success",
        "output": f"{output}\nEnemy status checked!",
        "is_correct": True,
        "explanation": (
            "The 'not' operator reverses a boolean value.\n"
            "It must be applied directly to `enemy_alive`.\n\n"
            "If the value is True, 'not' makes it False.\n"
            "If the value is False, 'not' makes it True.\n\n"
            "Examples of correct usage:\n"
            "print('not' enemy_alive)\n"
            "result = 'not' enemy_alive\n\n"
            "Quick Logic Check:\n"
            "'not' True  → False\n"
            "'not' False → True"
        )
    }
