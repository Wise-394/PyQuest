from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/18/question/2")
def get_question():
    return {
        "question": (
            "Create a Counter class that can count up and down!\n\n"
            "Write a class 'Counter' that:\n"
            "• Starts at 0\n"
            "• Has a method 'add' that adds 1 and returns the new count\n"
            "• Has a method 'subtract' that removes 1 and returns the new count\n"
            "• Has a method 'get_count' that returns the current count\n\n"
            "Example 1:\n"
            "Input: counter = Counter()\n"
            "       counter.add()\n"
            "Output: 1\n\n"
            "Example 2:\n"
            "Input: counter = Counter()\n"
            "       counter.add()\n"
            "       counter.add()\n"
            "       counter.subtract()\n"
            "Output: 1\n\n"
            "Example 3:\n"
            "Input: counter = Counter()\n"
            "       counter.get_count()\n"
            "Output: 0\n\n"
            "Hint: Use self.count to remember the number!"
        ),
        "code": ""
    }

@router.post("/level/18/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Classes That Remember Things![/b]\n\n"
        "[b]What you'll learn:[/b]\n"
        "Classes can remember values and change them!\n"
        "This is called 'state' - it's like the class has memory.\n\n"
        "[b]The Counter class:[/b]\n"
        "[color=red]class Counter:[/color]\n"
        "[color=red]    def __init__(self):[/color]\n"
        "[color=red]        self.count = 0  # Start at 0[/color]\n"
        "[color=red]    [/color]\n"
        "[color=red]    def add(self):[/color]\n"
        "[color=red]        self.count += 1  # Add 1[/color]\n"
        "[color=red]        return self.count[/color]\n"
        "[color=red]    [/color]\n"
        "[color=red]    def subtract(self):[/color]\n"
        "[color=red]        self.count -= 1  # Remove 1[/color]\n"
        "[color=red]        return self.count[/color]\n"
        "[color=red]    [/color]\n"
        "[color=red]    def get_count(self):[/color]\n"
        "[color=red]        return self.count[/color]\n\n"
        "[b]How it works:[/b]\n"
        "[color=red]counter = Counter()  # count starts at 0[/color]\n"
        "[color=red]counter.add()  # count becomes 1[/color]\n"
        "[color=red]counter.add()  # count becomes 2[/color]\n"
        "[color=red]counter.subtract()  # count becomes 1[/color]\n\n"
        "[b]Key idea:[/b]\n"
        "• [color=cyan]self.count[/color] remembers the number between method calls\n"
        "• Each Counter object has its own count!\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "This is like keeping score in a game - the class remembers!"
    )
    
    # Check if class is defined
    if "class Counter" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Class 'Counter' is not defined.\n"
                "Start with: class Counter:"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    required_methods = ["__init__", "add", "subtract", "get_count"]
    for method in required_methods:
        if f"def {method}" not in request.user_code:
            return {
                "status": "success",
                "output": (
                    f"Error: Method '{method}' is missing.\n"
                    f"Don't forget to add the '{method}' method!"
                ),
                "is_correct": False,
                "explanation": explanation
            }
    
    # Test cases: (operations, expected_results)
    test_cases = [
        ([("add",)], [1]),
        ([("add",), ("add",)], [1, 2]),
        ([("add",), ("add",), ("subtract",)], [1, 2, 1]),
        ([("get_count",)], [0]),
        ([("add",), ("add",), ("add",), ("subtract",), ("subtract",)], [1, 2, 3, 2, 1]),
        ([("add",), ("get_count",)], [1, 1]),
    ]
    
    try:
        # Execute user code to define the class
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "Counter" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Class 'Counter' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        Counter = exec_globals["Counter"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        for operations, expected_results in test_cases:
            try:
                counter = Counter()
                
                # Check count attribute
                if not hasattr(counter, 'count'):
                    output_lines.append(f"Test Case {passed + failed + 1}: Counter missing 'count' attribute - Failed")
                    failed += 1
                    continue
                
                # Perform operations
                results = []
                operation_strs = []
                for operation in operations:
                    method_name = operation[0]
                    result = getattr(counter, method_name)()
                    results.append(result)
                    operation_strs.append(f"{method_name}()")
                
                # Check results
                if results == expected_results:
                    ops_str = " → ".join(operation_strs)
                    output_lines.append(f"Test Case {passed + failed + 1}: {ops_str} ✓ Passed")
                    passed += 1
                else:
                    ops_str = " → ".join(operation_strs)
                    output_lines.append(f"Test Case {passed + failed + 1}: {ops_str} = {results} (expected {expected_results}) - Failed")
                    failed += 1
            except Exception as e:
                output_lines.append(f"Test Case {passed + failed + 1}: Error - {str(e)}")
                failed += 1
        
        output_lines.append(f"\nTest Results: {passed}/{len(test_cases)} passed")
        
        if passed == len(test_cases):
            output_lines.append("\n🎉 Excellent! Your counter works perfectly!")
            is_correct = True
        else:
            output_lines.append(f"\n{failed} test case(s) failed. Review your code!")
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
# class Counter:
#     def __init__(self):
#         self.count = 0
#     
#     def add(self):
#         self.count += 1
#         return self.count
#     
#     def subtract(self):
#         self.count -= 1
#         return self.count
#     
#     def get_count(self):
#         return self.count