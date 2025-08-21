from fastapi import FastAPI
from pydantic import BaseModel
import io
import sys
import traceback
import time

app = FastAPI()

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
        # Get the full traceback
        exc_type, exc_value, exc_traceback = sys.exc_info()
        traceback_details = traceback.extract_tb(exc_traceback)

        # Find the frame related to the user's code execution
        error_line_info = None
        for frame in traceback_details:
            # We are interested in the frame where the code was executed
            if '<string>' in frame.filename:
                error_line_info = frame
                break

        # Craft a user-friendly error message
        if error_line_info:
            error_message = f"Error on line {error_line_info.lineno}: {exc_type.__name__}: {exc_value}"
            if error_line_info.line:
                error_message += f"\nCode: {error_line_info.line.strip()}"
        else:
            # Fallback for unexpected errors
            error_message = f"{exc_type.__name__}: {exc_value}"

        return {"status": "error", "message": error_message}
    finally:
        sys.stdout = old_stdout