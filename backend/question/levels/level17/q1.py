from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/17/question/1")
def get_question():
    return {
        "question": (
            "Given a name and an optional greeting, return a formatted greeting message.\n\n"
            "Write a function 'greet' that takes:\n"
            "• name: string (required)\n"
            "• greeting: string (optional, default: 'Hello')\n\n"
            "Return: '{greeting}, {name}!'\n\n"
            "Example 1:\n"
            "Input: greet('Alice')\n"
            "Output: 'Hello, Alice!'\n"
            "Explanation: No greeting provided, so default 'Hello' is used.\n\n"
            "Example 2:\n"
            "Input: greet('Bob', 'Hi')\n"
            "Output: 'Hi, Bob!'\n\n"
            "Example 3:\n"
            "Input: greet('Charlie', 'Welcome')\n"
            "Output: 'Welcome, Charlie!'\n\n"
            "Constraints:\n"
            "• 1 <= len(name) <= 100\n"
            "• 1 <= len(greeting) <= 100\n"
            "• greeting parameter must have a default value of 'Hello'"
        ),
        "code": ""
    }

@router.post("/level/17/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Functions with Default Parameters![/b]\n\n"
        "[b]What are default parameters?[/b]\n"
        "Default parameters let you set a default value for a parameter.\n"
        "If the caller doesn't provide that argument, the default is used!\n\n"
        "[b]Syntax:[/b]\n"
        "[color=red]def greet(name, greeting='Hello'):[/color]\n"
        "[color=red]    return f'{greeting}, {name}!'[/color]\n\n"
        "[b]Using the function:[/b]\n"
        "[color=red]greet('World')  # Uses default 'Hello'[/color]\n"
        "[color=red]greet('World', 'Hi')  # Uses 'Hi'[/color]\n\n"
        "[b]Important Rules:[/b]\n"
        "• Default parameters must come AFTER required parameters\n"
        "• You can have multiple default parameters\n"
        "• Default values are set when the function is defined\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Default parameters make your functions more flexible!\n"
        "They're perfect for common values that rarely change."
    )
    
    # Check if function is defined
    if "def greet" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Function 'greet' is not defined.\n"
                "Please define a function with the signature: def greet(name, greeting='Hello'):"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Function must return a value.\n"
                "Use the 'return' statement to return the formatted greeting message."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test cases
    test_cases = [
        (("Alice",), {}, "Hello, Alice!"),
        (("Bob",), {"greeting": "Hi"}, "Hi, Bob!"),
        (("Charlie",), {"greeting": "Welcome"}, "Welcome, Charlie!"),
        (("David",), {}, "Hello, David!"),
        (("Eve",), {"greeting": "Good morning"}, "Good morning, Eve!"),
        (("Frank",), {"greeting": "Hey"}, "Hey, Frank!"),
    ]
    
    try:
        # Execute user code to define the function
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "greet" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Function 'greet' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        user_function = exec_globals["greet"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        for args, kwargs, expected in test_cases:
            try:
                result = user_function(*args, **kwargs)
                if result == expected:
                    if kwargs:
                        output_lines.append(f"Test Case {passed + failed + 1}: greet('{args[0]}', '{kwargs['greeting']}') = '{result}' - Passed")
                    else:
                        output_lines.append(f"Test Case {passed + failed + 1}: greet('{args[0]}') = '{result}' - Passed")
                    passed += 1
                else:
                    if kwargs:
                        output_lines.append(f"Test Case {passed + failed + 1}: greet('{args[0]}', '{kwargs['greeting']}') = '{result}' (expected '{expected}') - Failed")
                    else:
                        output_lines.append(f"Test Case {passed + failed + 1}: greet('{args[0]}') = '{result}' (expected '{expected}') - Failed")
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
# def greet(name, greeting='Hello'):
#     return f'{greeting}, {name}!'