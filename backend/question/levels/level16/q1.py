from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/16/question/1")
def get_question():
    return {
        "question": (
            "Write a function called 'check_even_odd' that:\n"
            "• Takes one parameter: number (an integer)\n"
            "• Returns 'even' if the number is even\n"
            "• Returns 'odd' if the number is odd\n\n"
            "Your function will be tested with multiple test cases.\n\n"
            "Example:\n"
            "check_even_odd(4) → should return 'even'\n"
            "check_even_odd(7) → should return 'odd'"
        ),
        "code": ""
    }

@router.post("/level/16/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Functions with Return Values![/b]\n\n"
        "[b]What is 'return'?[/b]\n"
        "The 'return' keyword sends a value back from a function.\n"
        "Think of it as the function's answer!\n\n"
        "[b]Syntax:[/b]\n"
        "[color=red]def function_name(parameter):[/color]\n"
        "[color=red]    result = parameter * 2[/color]\n"
        "[color=red]    return result[/color]\n\n"
        "[b]Using the returned value:[/b]\n"
        "[color=red]answer = function_name(5)[/color]\n"
        "[color=red]print(answer)  # prints: 10[/color]\n\n"
        "[b]Checking Even or Odd:[/b]\n"
        "Use the modulo operator (%) to check divisibility:\n"
        "[color=red]number % 2 == 0[/color] → True if even\n"
        "[color=red]number % 2 != 0[/color] → True if odd\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Return values let functions give you results to use elsewhere!\n"
        "You can store them in variables or use them in calculations."
    )
    
    # Check if function is defined
    if "def check_even_odd" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "❌ You need to define a function called 'check_even_odd'.\n"
                "Use: def check_even_odd(number):"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "❌ Your function needs to return a value!\n"
                "Use 'return' to send back 'even' or 'odd'."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test cases
    test_cases = [
        (4, "even"),
        (7, "odd"),
        (0, "even"),
        (1, "odd"),
        (100, "even"),
        (999, "odd"),
        (-2, "even"),
        (-5, "odd"),
    ]
    
    try:
        # Execute user code to define the function
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "check_even_odd" not in exec_globals:
            return {
                "status": "success",
                "output": "❌ Function 'check_even_odd' not found!",
                "is_correct": False,
                "explanation": explanation
            }
        
        user_function = exec_globals["check_even_odd"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running Test Cases:\n"]
        
        for number, expected in test_cases:
            try:
                result = user_function(number)
                if result == expected:
                    output_lines.append(f"✅ Test {passed + failed + 1}: check_even_odd({number}) = '{result}'PASS")
                    passed += 1
                else:
                    output_lines.append(f"❌ Test {passed + failed + 1}: check_even_odd({number}) = '{result}' (expected '{expected}') FAIL")
                    failed += 1
            except Exception as e:
                output_lines.append(f"❌ Test {passed + failed + 1}: check_even_odd({number}) ERROR: {str(e)}")
                failed += 1
        
        output_lines.append(f"\nResults: {passed}/{len(test_cases)} tests passed")
        
        if passed == len(test_cases):
            output_lines.append("\n✅ All tests passed! Great job!")
            output_lines.append("⚔️ You've mastered return values!")
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
# def check_even_odd(number):
#     if number % 2 == 0:
#         return "even"
#     else:
#         return "odd"