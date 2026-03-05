from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class CodeRequest(BaseModel):
    code: str

@router.post("/execute")
def execute_code(request: CodeRequest):
    output = execute_user_code(request.code)
    return { "output": output }