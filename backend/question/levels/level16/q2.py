from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/16/question/2")
def get_question():
    return {
        "question": (
            "Write a function called 'calculate_area' that:\n"
            "• Takes two parameters: length and width\n"
            "• Returns the area of the rectangle (length × width)\n\n"
            "Your function will be tested with multiple test cases.\n\n"
            "Example:\n"
            "calculate_area(5, 3) → should return 15\n"
            "calculate_area(10, 2) → should return 20"
        ),
        "code": ""
    }

@router.post("/level/16/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Functions with Multiple Parameters![/b]\n\n"
        "[b]Multiple Parameters:[/b]\n"
        "Separate parameters with commas.\n\n"
        "[b]Syntax:[/b]\n"
        "[color=red]def function_name(param1, param2):[/color]\n"
        "[color=red]    result = param1 + param2[/color]\n"
        "[color=red]    return result[/color]\n\n"
        "[b]Calling with multiple arguments:[/b]\n"
        "[color=red]answer = function_name(5, 10)[/color]\n"
        "The first value goes to param1, second to param2.\n\n"
        "[b]Rectangle Area Formula:[/b]\n"
        "[color=red]area = length × width[/color]\n"
        "Use the * operator for multiplication in Python.\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Multiple parameters let your functions work with more data!\n"
        "Think of them as multiple ingredients for a recipe."
    )
    
    # Check if function is defined
    if "def calculate_area" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "❌ You need to define a function called 'calculate_area'.\n"
                "Use: def calculate_area(length, width):"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "❌ Your function needs to return the calculated area!\n"
                "Use 'return' to send back the result."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test cases: (length, width, expected_area)
    test_cases = [
        (5, 3, 15),
        (10, 2, 20),
        (7, 7, 49),
        (1, 1, 1),
        (100, 50, 5000),
        (15, 4, 60),
        (8, 12, 96),
        (25, 10, 250),
    ]
    
    try:
        # Execute user code to define the function
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "calculate_area" not in exec_globals:
            return {
                "status": "success",
                "output": "❌ Function 'calculate_area' not found!",
                "is_correct": False,
                "explanation": explanation
            }
        
        user_function = exec_globals["calculate_area"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running Test Cases:\n"]
        
        for length, width, expected in test_cases:
            try:
                result = user_function(length, width)
                if result == expected:
                    output_lines.append(f"✅ Test {passed + failed + 1}: calculate_area({length}, {width}) = {result} PASS")
                    passed += 1
                else:
                    output_lines.append(f"❌ Test {passed + failed + 1}: calculate_area({length}, {width}) = {result} (expected {expected}) FAIL")
                    failed += 1
            except Exception as e:
                output_lines.append(f"❌ Test {passed + failed + 1}: calculate_area({length}, {width}) ERROR: {str(e)}")
                failed += 1
        
        output_lines.append(f"\nResults: {passed}/{len(test_cases)} tests passed")
        
        if passed == len(test_cases):
            output_lines.append("\n✅ All tests passed! Excellent work!")
            output_lines.append("⚔️ You've mastered multiple parameters!")
            is_correct = True
        else:
            output_lines.append(f"\n❌ {failed} test(s) failed. Keep trying!")
            is_correct = False
        
        return {
            "status": "success",
            "output": "\n".join(output_lines),
            "is_correct": is_correct,
            "explanation": explanation
        }
        
    except Exception as e:
        return {
            "status": "success",
            "output": f"Error executing your code: {str(e)}",
            "is_correct": False,
            "explanation": explanation
        }

# Correct answer:
# def calculate_area(length, width):
#     return length * width