from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/17/question/2")
def get_question():
    return {
        "question": (
            "Given a base number and an optional exponent, return the result of base raised to the power of exponent.\n\n"
            "Write a function 'power' that takes:\n"
            "• base: number (required)\n"
            "• exponent: number (optional, default: 2)\n\n"
            "Return: base ** exponent\n\n"
            "Example 1:\n"
            "Input: power(5)\n"
            "Output: 25\n"
            "Explanation: No exponent provided, so default 2 is used. 5^2 = 25\n\n"
            "Example 2:\n"
            "Input: power(3, 3)\n"
            "Output: 27\n"
            "Explanation: 3^3 = 3 × 3 × 3 = 27\n\n"
            "Example 3:\n"
            "Input: power(2, 4)\n"
            "Output: 16\n"
            "Explanation: 2^4 = 2 × 2 × 2 × 2 = 16\n\n"
            "Example 4:\n"
            "Input: power(10)\n"
            "Output: 100\n"
            "Explanation: 10^2 = 100\n\n"
            "• exponent parameter must have a default value of 2"
        ),
        "code": ""
    }

@router.post("/level/17/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]📚 SPELL TOME: POWER MAGIC[/b]\n\n"
        "[b]⚡ The Art of Multiplication Magic[/b]\n"
        "Power spells multiply a number by itself multiple times!\n"
        "Most mages square their power (×2), so we make it the default.\n\n"
        "[b]✨ Spell Formula:[/b]\n"
        "[color=red]def power(base, exponent=2):[/color]\n"
        "[color=red]    return base ** exponent[/color]\n\n"
        "[b]🔥 The ** Operator (Power Symbol):[/b]\n"
        "[color=red]2 ** 3  # 8 (2 × 2 × 2)[/color]\n"
        "[color=red]5 ** 2  # 25 (5 × 5)[/color]\n"
        "[color=red]10 ** 4  # 10000 (10 × 10 × 10 × 10)[/color]\n\n"
        "[b]🎯 Casting Examples:[/b]\n"
        "[color=red]power(5)      # Default square: 5² = 25[/color]\n"
        "[color=red]power(5, 3)   # Custom cube: 5³ = 125[/color]\n\n"
        "[color=yellow]🎮 Mage's Secret:[/color]\n"
        "Default exponent=2 is perfect because squaring is the most\n"
        "common power operation! Your spell is optimized for common use."
    )
    
    # Check if function is defined
    if "def power" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Function 'power' is not defined.\n"
                "Please define a function with the signature: def power(base, exponent=2):"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Function must return a value.\n"
                "Use the 'return' statement to return base ** exponent."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test cases
    test_cases = [
        ((5,), {}, 25),
        ((3,), {"exponent": 3}, 27),
        ((2,), {"exponent": 4}, 16),
        ((10,), {}, 100),
        ((7,), {}, 49),
        ((4,), {"exponent": 3}, 64),
        ((2,), {"exponent": 5}, 32),
        ((1,), {"exponent": 100}, 1),
    ]
    
    try:
        # Execute user code to define the function
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "power" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Function 'power' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        user_function = exec_globals["power"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        for args, kwargs, expected in test_cases:
            try:
                result = user_function(*args, **kwargs)
                if result == expected:
                    if kwargs:
                        output_lines.append(f"Test Case {passed + failed + 1}: power({args[0]}, {kwargs['exponent']}) = {result} - Passed")
                    else:
                        output_lines.append(f"Test Case {passed + failed + 1}: power({args[0]}) = {result} - Passed")
                    passed += 1
                else:
                    if kwargs:
                        output_lines.append(f"Test Case {passed + failed + 1}: power({args[0]}, {kwargs['exponent']}) = {result} (expected {expected}) - Failed")
                    else:
                        output_lines.append(f"Test Case {passed + failed + 1}: power({args[0]}) = {result} (expected {expected}) - Failed")
                    failed += 1
            except Exception as e:
                output_lines.append(f"Test Case {passed + failed + 1}: Runtime Error - {str(e)}")
                failed += 1
        
        output_lines.append(f"\nTest Results: {passed}/{len(test_cases)} passed")
        
        if passed == len(test_cases):
            output_lines.append("\nAll test cases passed successfully!")
            is_correct = True
        else:
            output_lines.append(f"\n{failed} test case(s) failed. Please review your implementation.")
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
# def power(base, exponent=2):
#     return base ** exponent