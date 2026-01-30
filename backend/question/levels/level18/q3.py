from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/18/question/3")
def get_question():
    return {
        "question": (
            "Create a Car class with a brand and color!\n\n"
            "Write a class 'Car' that:\n"
            "• Takes 'brand' and 'color' when created\n"
            "• Has a method 'describe' that returns: 'This is a {color} {brand}'\n"
            "• Has a method 'honk' that returns: 'The {brand} goes Beep beep!'\n\n"
            "Example 1:\n"
            "Input: car = Car('Toyota', 'red')\n"
            "       car.describe()\n"
            "Output: 'This is a red Toyota'\n\n"
            "Example 2:\n"
            "Input: car = Car('Honda', 'blue')\n"
            "       car.honk()\n"
            "Output: 'The Honda goes Beep beep!'\n\n"
            "Example 3:\n"
            "Input: car = Car('Tesla', 'white')\n"
            "       car.describe()\n"
            "Output: 'This is a white Tesla'\n\n"
            "Hint: Save both brand and color in __init__!"
        ),
        "code": ""
    }

@router.post("/level/18/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Classes with Multiple Attributes![/b]\n\n"
        "[b]What you'll learn:[/b]\n"
        "A class can save multiple pieces of information.\n"
        "Then any method can use any of that information!\n\n"
        "[b]The Car class:[/b]\n"
        "[color=red]class Car:[/color]\n"
        "[color=red]    def __init__(self, brand, color):[/color]\n"
        "[color=red]        self.brand = brand  # Save brand[/color]\n"
        "[color=red]        self.color = color  # Save color[/color]\n"
        "[color=red]    [/color]\n"
        "[color=red]    def describe(self):[/color]\n"
        "[color=red]        return f'This is a {self.color} {self.brand}'[/color]\n"
        "[color=red]    [/color]\n"
        "[color=red]    def honk(self):[/color]\n"
        "[color=red]        return f'The {self.brand} goes Beep beep!'[/color]\n\n"
        "[b]How it works:[/b]\n"
        "[color=red]my_car = Car('Toyota', 'red')[/color]\n"
        "[color=red]my_car.describe()  # Uses both color and brand[/color]\n"
        "[color=red]my_car.honk()      # Uses just brand[/color]\n\n"
        "[b]Key points:[/b]\n"
        "• Save all the info you need in __init__\n"
        "• Different methods can use the same saved info\n"
        "• Each Car object remembers its own brand and color\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Think of a class like a character in a game - it has traits (brand, color)\n"
        "and can do actions (describe, honk)!"
    )
    
    # Check if class is defined
    if "class Car" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Class 'Car' is not defined.\n"
                "Start with: class Car:"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    required_methods = ["__init__", "describe", "honk"]
    for method in required_methods:
        if f"def {method}" not in request.user_code:
            return {
                "status": "success",
                "output": (
                    f"Error: Method '{method}' is missing.\n"
                    f"Add the '{method}' method to your Car class!"
                ),
                "is_correct": False,
                "explanation": explanation
            }
    
    # Test cases: (brand, color, expected_describe, expected_honk)
    test_cases = [
        ("Toyota", "red", "This is a red Toyota", "The Toyota goes Beep beep!"),
        ("Honda", "blue", "This is a blue Honda", "The Honda goes Beep beep!"),
        ("Tesla", "white", "This is a white Tesla", "The Tesla goes Beep beep!"),
        ("BMW", "black", "This is a black BMW", "The BMW goes Beep beep!"),
        ("Ford", "green", "This is a green Ford", "The Ford goes Beep beep!"),
    ]
    
    try:
        # Execute user code to define the class
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "Car" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Class 'Car' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        Car = exec_globals["Car"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        for brand, color, expected_describe, expected_honk in test_cases:
            try:
                car = Car(brand, color)
                
                # Check attributes
                if not hasattr(car, 'brand') or not hasattr(car, 'color'):
                    output_lines.append(f"Test Case {passed + failed + 1}: Missing 'brand' or 'color' attributes - Failed")
                    failed += 1
                    continue
                
                # Check describe
                describe_result = car.describe()
                if describe_result != expected_describe:
                    output_lines.append(f"Test Case {passed + failed + 1}: Car('{brand}', '{color}').describe() = '{describe_result}' (expected '{expected_describe}') - Failed")
                    failed += 1
                    continue
                
                # Check honk
                honk_result = car.honk()
                if honk_result != expected_honk:
                    output_lines.append(f"Test Case {passed + failed + 1}: Car('{brand}', '{color}').honk() = '{honk_result}' (expected '{expected_honk}') - Failed")
                    failed += 1
                    continue
                
                output_lines.append(f"Test Case {passed + failed + 1}: Car('{brand}', '{color}') ✓ Passed")
                passed += 1
                
            except Exception as e:
                output_lines.append(f"Test Case {passed + failed + 1}: Error - {str(e)}")
                failed += 1
        
        output_lines.append(f"\nTest Results: {passed}/{len(test_cases)} passed")
        
        if passed == len(test_cases):
            output_lines.append("\n🎉 Amazing! Your cars are ready to drive!")
            is_correct = True
        else:
            output_lines.append(f"\n{failed} test case(s) failed. Check your methods!")
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
# class Car:
#     def __init__(self, brand, color):
#         self.brand = brand
#         self.color = color
#     
#     def describe(self):
#         return f'This is a {self.color} {self.brand}'
#     
#     def honk(self):
#         return f'The {self.brand} goes Beep beep!'