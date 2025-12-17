import io
import contextlib

def execute_user_code(code: str) -> str:
    buffer = io.StringIO()
    try:
        with contextlib.redirect_stdout(buffer):
            exec(code, {})
        return buffer.getvalue().strip()
    except Exception as e:
        return f"Error: {str(e)}"
    finally:
        buffer.close()