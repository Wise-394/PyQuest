from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code
import re

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/3/question/2")
def get_question():
    return {"question": "Create a variable named 'NPC' with a string value containing the name of an NPC you just talked to", "code" : ""}

@router.post("/level/3/question/2")
def post_user_code(request: UserCodeRequest):
    user_code = request.user_code
    
    # Check if variable 'NPC' exists in the code
    npc_match = re.search(r'\bNPC\s*=\s*["\']([^"\']+)["\']', user_code)
    if not npc_match:
        return {
            "status": "error",
            "output": "Variable 'NPC' not found or not assigned a string value. Remember you need to use single or double quotations for strings",
            "is_correct": False,
            "explanation": ""
        }
    
    # Get the value assigned to 'NPC'
    npc_value = npc_match.group(1)
    
    # Check if the string is not empty
    if not npc_value or len(npc_value.strip()) == 0:
        return {
            "status": "error",
            "output": "Variable 'NPC' cannot be an empty string",
            "is_correct": False,
            "explanation": "The variable 'NPC' must contain a valid NPC name"
        }
    
    # Check if the NPC name is "starfish" (case-insensitive)
    if npc_value.lower() != "starfish":
        return {
            "status": "error",
            "output": f"Variable 'NPC' has value '{npc_value}', but the NPC you just talked to was named 'starfish'",
            "is_correct": False,
            "explanation": "Remember the name of the NPC from your conversation"
        }
    
    # Execute the user code to verify it runs without errors
    try:
        output = execute_user_code(user_code)
    except Exception as e:
        return {
            "status": "error",
            "output": f"Error executing code: {str(e)}",
            "is_correct": False,
            "explanation": ""
        }
        
    explanation = (
    "[b]String Data Type (str)[/b] is used to store text in Python.\n\n"
    "In this example:\n"
    "[color=red]NPC = \"starfish\"[/color]\n"
    "The value [b]\"starfish\"[/b] is text, so its data type is a [b]string (str)[/b].\n\n"
    "Strings must be written inside [b]single (' ')[/b] or [b]double (\" \") quotations[/b].\n"
    "Without quotations, Python will think the value is a variable name instead of text.\n\n"
    "When you create the variable [b]NPC[/b], you are storing the NPC’s name as a string.\n\n"
    "You successfully used the [b]str[/b] data type and assigned it to a variable correctly."
)
    # All checks passed
    message = f"Correct! You created the variable 'NPC' with the value '{npc_value}'"
    return {
        "status": "success",
        "output": message,
        "is_correct": True,
        "explanation": explanation
    }