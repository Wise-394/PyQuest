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
    start_time = time.time()  # Start timer
    old_stdout = sys.stdout
    redirected_output = io.StringIO()
    sys.stdout = redirected_output

    try:
        exec(request.code)
        output = redirected_output.getvalue()

        end_time = time.time()
        exec_time = end_time - start_time  # measure execution time

        return {
            "status": "success",
            "output": output,
            "exec_time": f"{exec_time:.6f} seconds"  # <-- return exec time
        }
    except Exception as e:
        error_message = f"{e.__class__.__name__}: {e}\n{traceback.format_exc()}"
        return {"status": "error", "message": error_message}
    finally:
        sys.stdout = old_stdout
