from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import io
import sys
import traceback
import time
import json

app = FastAPI()

# Load questions from questions.json at startup
with open("questions.json", "r") as f:
    questions = json.load(f)

class CodeRequest(BaseModel):
    code: str
    question_id: int  # identify which question to check

def check_code_output(user_output: str, expected_output: str) -> bool:
    """
    Checks if the user's output matches the expected output.
    You can modify this function later to allow for flexible checks,
    e.g., ignoring whitespace, newlines, capitalization, etc.
    """
    return user_output.strip() == expected_output.strip()

@app.post("/execute_code/")
async def execute_user_code(request: CodeRequest):
    # Find the question by id
    question = next((q for q in questions if q["id"] == request.question_id), None)
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")

    start_time = time.time()
    old_stdout = sys.stdout
    redirected_output = io.StringIO()
    sys.stdout = redirected_output

    try:
        exec(request.code)
        output = redirected_output.getvalue().strip()
        end_time = time.time()
        exec_time = end_time - start_time

        # Use the checker function
        is_correct = check_code_output(output, question["desired_output"])

        return {
            "status": "success",
            "output": output,
            "exec_time": f"{exec_time:.6f} seconds",
            "correct": is_correct,
            "expected_output": question["desired_output"]
        }

    except Exception as e:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        traceback_details = traceback.extract_tb(exc_traceback)

        error_line_info = None
        for frame in traceback_details:
            if '<string>' in frame.filename:
                error_line_info = frame
                break

        if error_line_info:
            error_message = f"Error on line {error_line_info.lineno}: {exc_type.__name__}: {exc_value}"
            if error_line_info.line:
                error_message += f"\nCode: {error_line_info.line.strip()}"
        else:
            error_message = f"{exc_type.__name__}: {exc_value}"

        return {"status": "error", "message": error_message}
    finally:
        sys.stdout = old_stdout


@app.get("/get_question/{question_id}")
async def get_question(question_id: int):
    for q in questions:
        if q["id"] == question_id:
            response = q.copy()
            response["status"] = "question"
            return response
    raise HTTPException(status_code=404, detail="Question not found")
