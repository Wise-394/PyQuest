from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/18/question/1")
def get_question():
    return {
        "question": (
            "Create your first Python class - a Dog!\n\n"
            "Write a class 'Dog' that:\n"
            "• Takes a 'name' when created\n"
            "• Has a method 'bark' that returns: '{name} says Woof!'\n\n"
            "Example 1:\n"
            "Input: dog = Dog('Buddy')\n"
            "       dog.bark()\n"
            "Output: 'Buddy says Woof!'\n\n"
            "Example 2:\n"
            "Input: dog = Dog('Max')\n"
            "       dog.bark()\n"
            "Output: 'Max says Woof!'\n\n"
            "Example 3:\n"
            "Input: dog = Dog('Luna')\n"
            "       dog.bark()\n"
            "Output: 'Luna says Woof!'\n\n"
            "Hint: You need __init__ to save the name, and bark to use it!"
        ),
        "code": ""
    }

@router.post("/level/18/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Your First Python Class![/b]\n\n"
        "[b]What is a class?[/b]\n"
        "Think of a class like a recipe. It tells Python how to create something.\n"
        "Here, we're creating Dogs!\n\n"
        "[b]Step 1: Define the class[/b]\n"
        "[color=red]class Dog:[/color]\n\n"
        "[b]Step 2: The __init__ method (setup)[/b]\n"
        "[color=red]    def __init__(self, name):[/color]\n"
        "[color=red]        self.name = name[/color]\n"
        "This saves the dog's name when you create it.\n\n"
        "[b]Step 3: Add a method (action)[/b]\n"
        "[color=red]    def bark(self):[/color]\n"
        "[color=red]        return f'{self.name} says Woof!'[/color]\n\n"
        "[b]How to use it:[/b]\n"
        "[color=red]dog = Dog('Buddy')  # Create a dog named Buddy[/color]\n"
        "[color=red]dog.bark()  # Make the dog bark[/color]\n"
        "[color=red]# Returns: 'Buddy says Woof!'[/color]\n\n"
        "[b]Important:[/b]\n"
        "• [color=cyan]self[/color] means 'this dog' - it refers to the specific dog object\n"
        "• [color=cyan]self.name[/color] saves the name inside the dog\n\n"
        "[color=yellow]🎮 Game Tip:[/color]\n"
        "Every method needs 'self' as the first parameter!"
    )
    
    # Check if class is defined
    if "class Dog" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Class 'Dog' is not defined.\n"
                "Start with: class Dog:"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "__init__" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Missing __init__ method.\n"
                "You need __init__ to save the dog's name when it's created!"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "def bark" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Missing 'bark' method.\n"
                "Add a bark method that makes your dog say Woof!"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test cases
    test_cases = [
        ("Buddy", "Buddy says Woof!"),
        ("Max", "Max says Woof!"),
        ("Luna", "Luna says Woof!"),
        ("Charlie", "Charlie says Woof!"),
        ("Bella", "Bella says Woof!"),
    ]
    
    try:
        # Execute user code to define the class
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "Dog" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Class 'Dog' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        Dog = exec_globals["Dog"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        for name, expected_bark in test_cases:
            try:
                dog = Dog(name)
                
                # Check name attribute
                if not hasattr(dog, 'name'):
                    output_lines.append(f"Test Case {passed + failed + 1}: Dog doesn't have a 'name' attribute - Failed")
                    failed += 1
                    continue
                
                if dog.name != name:
                    output_lines.append(f"Test Case {passed + failed + 1}: Dog's name is '{dog.name}' but should be '{name}' - Failed")
                    failed += 1
                    continue
                
                # Check bark method
                if not hasattr(dog, 'bark'):
                    output_lines.append(f"Test Case {passed + failed + 1}: Dog doesn't have a 'bark' method - Failed")
                    failed += 1
                    continue
                
                result = dog.bark()
                if result == expected_bark:
                    output_lines.append(f"Test Case {passed + failed + 1}: Dog('{name}').bark() = '{result}' ✓ Passed")
                    passed += 1
                else:
                    output_lines.append(f"Test Case {passed + failed + 1}: Dog('{name}').bark() = '{result}' (expected '{expected_bark}') - Failed")
                    failed += 1
            except Exception as e:
                output_lines.append(f"Test Case {passed + failed + 1}: Error - {str(e)}")
                failed += 1
        
        output_lines.append(f"\nTest Results: {passed}/{len(test_cases)} passed")
        
        if passed == len(test_cases):
            output_lines.append("\n🎉 Perfect! All dogs are barking correctly!")
            is_correct = True
        else:
            output_lines.append(f"\n{failed} test case(s) failed. Check your code and try again!")
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
# class Dog:
#     def __init__(self, name):
#         self.name = name
#     
#     def bark(self):
#         return f'{self.name} says Woof!'