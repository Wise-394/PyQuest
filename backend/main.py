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

@app.post("/execute_code/")
async def execute_user_code(request: CodeRequest):
    start_time = time.time()
    old_stdout = sys.stdout
    redirected_output = io.StringIO()
    sys.stdout = redirected_output

    try:
        exec(request.code)
        output = redirected_output.getvalue()
        end_time = time.time()
        exec_time = end_time - start_time
        return {
            "status": "success",
            "output": output,
            "exec_time": f"{exec_time:.6f} seconds"
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
            # Return the whole question dict inside a "status": "question" response
            response = q.copy()  # copy so we don’t modify the original
            response["status"] = "question"
            return response
    raise HTTPException(status_code=404, detail="Question not found")