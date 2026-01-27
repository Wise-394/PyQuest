from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/16/question/3")
def get_question():
    return {
        "question": (
            "Write a function called 'calculate_average' that:\n"
            "• Takes one parameter: numbers (a list of numbers)\n"
            "• Returns the average of all numbers in the list\n"
            "• The average = sum of all numbers ÷ count of numbers\n\n"
            "Your function will be tested with multiple test cases.\n\n"
            "Example:\n"
            "calculate_average([10, 20, 30]) → should return 20.0\n"
            "calculate_average([5, 10, 15, 20]) → should return 12.5"
        ),
        "code": ""
    }

@router.post("/level/16/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Working with Lists - Calculate Average![/b]\n\n"
        "[b]What is an Average?[/b]\n"
        "The average (mean) is the sum of all values divided by the count.\n"
        "Formula: [color=red]average = sum / count[/color]\n\n"
        "[b]List Operations You Need:[/b]\n"
        "• [color=cyan]sum(list)[/color] - adds all numbers in a list\n"
        "• [color=cyan]len(list)[/color] - counts how many items in a list\n\n"
        "[b]Example:[/b]\n"
        "[color=red]numbers = [10, 20, 30][/color]\n"
        "[color=red]total = sum(numbers)      # 60[/color]\n"
        "[color=red]count = len(numbers)      # 3[/color]\n"
        "[color=red]average = total / count   # 20.0[/color]\n\n"
        "[b]Division in Python:[/b]\n"
        "• [color=cyan]/[/color] gives decimal result (10 / 4 = 2.5)\n"
        "• [color=cyan]//[/color] gives whole number (10 // 4 = 2)\n"
        "Use / for average to get accurate results!\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Average is useful for calculating player stats,\n"
        "damage over time, or team performance!"
    )
    
    # Check if function is defined
    if "def calculate_average" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "❌ You need to define a function called 'calculate_average'.\n"
                "Use: def calculate_average(numbers):"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "❌ Your function needs to return the calculated average!\n"
                "Use 'return' to send back the result."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test cases: (list, expected_average)
    test_cases = [
        ([10, 20, 30], 20.0),
        ([5, 10, 15, 20], 12.5),
        ([100], 100.0),
        ([1, 2, 3, 4, 5], 3.0),
        ([50, 50, 50, 50], 50.0),
        ([7, 14, 21, 28, 35], 21.0),
        ([2, 4, 6, 8, 10, 12], 7.0),
        ([15, 25, 35, 45], 30.0),
    ]
    
    try:
        # Execute user code to define the function
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "calculate_average" not in exec_globals:
            return {
                "status": "success",
                "output": "❌ Function 'calculate_average' not found!",
                "is_correct": False,
                "explanation": explanation
            }
        
        user_function = exec_globals["calculate_average"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running Test Cases:\n"]
        
        for numbers, expected in test_cases:
            try:
                result = user_function(numbers)
                # Check if result is close enough (handle floating point precision)
                if abs(result - expected) < 0.0001:
                    output_lines.append(f"✅ Test {passed + failed + 1}: calculate_average({numbers}) = {result} PASS")
                    passed += 1
                else:
                    output_lines.append(f"❌ Test {passed + failed + 1}: calculate_average({numbers}) = {result} (expected {expected}) FAIL")
                    failed += 1
            except ZeroDivisionError:
                output_lines.append(f"❌ Test {passed + failed + 1}: calculate_average({numbers}) ERROR: Division by zero")
                failed += 1
            except Exception as e:
                output_lines.append(f"❌ Test {passed + failed + 1}: calculate_average({numbers}) ERROR: {str(e)}")
                failed += 1
        
        output_lines.append(f"\nResults: {passed}/{len(test_cases)} tests passed")
        
        if passed == len(test_cases):
            output_lines.append("\n✅ All tests passed! Excellent work!")
            output_lines.append("⚔️ You've mastered list calculations!")
            is_correct = True
        else:
            output_lines.append(f"\n❌ {failed} test(s) failed. Keep trying!")
            output_lines.append("\nHint: Use sum(numbers) / len(numbers)")
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
# def calculate_average(numbers):
#     return sum(numbers) / len(numbers)
#
# Alternative solution:
# def calculate_average(numbers):
#     total = sum(numbers)
#     count = len(numbers)
#     return total / count