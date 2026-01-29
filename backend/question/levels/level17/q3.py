from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/17/question/3")
def get_question():
    return {
        "question": (
            "Given a name and optional age and country, return a formatted profile string.\n\n"
            "Write a function 'create_profile' that takes:\n"
            "• name: string (required)\n"
            "• age: integer (optional, default: 18)\n"
            "• country: string (optional, default: 'Unknown')\n\n"
            "Return: 'Name: {name}, Age: {age}, Country: {country}'\n\n"
            "Example 1:\n"
            "Input: create_profile('Alice')\n"
            "Output: 'Name: Alice, Age: 18, Country: Unknown'\n"
            "Explanation: No age or country provided, both defaults are used.\n\n"
            "Example 2:\n"
            "Input: create_profile('Bob', 25)\n"
            "Output: 'Name: Bob, Age: 25, Country: Unknown'\n"
            "Explanation: Custom age provided, country uses default.\n\n"
            "Example 3:\n"
            "Input: create_profile('Charlie', 30, 'USA')\n"
            "Output: 'Name: Charlie, Age: 30, Country: USA'\n"
            "Explanation: All parameters provided.\n\n"
            "Example 4:\n"
            "Input: create_profile('Eve', country='Canada')\n"
            "Output: 'Name: Eve, Age: 18, Country: Canada'\n"
            "• age parameter must have a default value of 18\n"
            "• country parameter must have a default value of 'Unknown'"
        ),
        "code": ""
    }

@router.post("/level/17/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]📚 SPELL TOME: MULTIPLE DEFAULT PARAMETERS[/b]\n\n"
        "[b]🎯 The Ultimate Flexibility Spell![/b]\n"
        "You can have MULTIPLE default parameters in one spell!\n"
        "This is perfect for character creation systems.\n\n"
        "[b]✨ Advanced Spell Formula:[/b]\n"
        "[color=red]def create_profile(name, age=18, country='Unknown'):[/color]\n"
        "[color=red]    return f'Name: {name}, Age: {age}, Country: {country}'[/color]\n\n"
        "[b]🎭 Different Ways to Cast:[/b]\n"
        "[color=red]create_profile('Hero')  # Both defaults used[/color]\n"
        "[color=red]create_profile('Hero', 25)  # Custom age, default country[/color]\n"
        "[color=red]create_profile('Hero', 25, 'USA')  # All custom[/color]\n"
        "[color=red]create_profile('Hero', country='USA')  # Skip age, set country[/color]\n\n"
        "[b]⚡ Sacred Rules:[/b]\n"
        "• Required parameters (name) come FIRST\n"
        "• Default parameters come AFTER\n"
        "• You can use keyword arguments to skip defaults\n\n"
        "[color=yellow]🎮 Guild Master's Wisdom:[/color]\n"
        "Multiple defaults let adventurers provide only what they remember!\n"
        "Your spell handles missing info gracefully. True magic!"
    )
    
    # Check if function is defined
    if "def create_profile" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Function 'create_profile' is not defined.\n"
                "Please define a function with the signature: def create_profile(name, age=18, country='Unknown'):"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    if "return" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Function must return a value.\n"
                "Use the 'return' statement to return the formatted profile string."
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    # Test cases
    test_cases = [
        (("Alice",), {}, "Name: Alice, Age: 18, Country: Unknown"),
        (("Bob",), {"age": 25}, "Name: Bob, Age: 25, Country: Unknown"),
        (("Charlie",), {"age": 30, "country": "USA"}, "Name: Charlie, Age: 30, Country: USA"),
        (("David",), {}, "Name: David, Age: 18, Country: Unknown"),
        (("Eve",), {"country": "Canada"}, "Name: Eve, Age: 18, Country: Canada"),
        (("Frank",), {"age": 22, "country": "UK"}, "Name: Frank, Age: 22, Country: UK"),
        (("Grace",), {"age": 35}, "Name: Grace, Age: 35, Country: Unknown"),
        (("Henry",), {"country": "Japan"}, "Name: Henry, Age: 18, Country: Japan"),
    ]
    
    try:
        # Execute user code to define the function
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "create_profile" not in exec_globals:
            return {
                "status": "success",
                "output": "❌ Function 'create_profile' not found!",
                "is_correct": False,
                "explanation": explanation
            }
        
        user_function = exec_globals["create_profile"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        for args, kwargs, expected in test_cases:
            try:
                result = user_function(*args, **kwargs)
                if result == expected:
                    # Build test description
                    test_desc = f"create_profile('{args[0]}'"
                    if "age" in kwargs:
                        test_desc += f", {kwargs['age']}"
                    if "country" in kwargs:
                        if "age" not in kwargs:
                            test_desc += f", country='{kwargs['country']}'"
                        else:
                            test_desc += f", '{kwargs['country']}'"
                    test_desc += ")"
                    
                    output_lines.append(f"Test Case {passed + failed + 1}: {test_desc} - Passed")
                    passed += 1
                else:
                    # Build test description
                    test_desc = f"create_profile('{args[0]}'"
                    if "age" in kwargs:
                        test_desc += f", {kwargs['age']}"
                    if "country" in kwargs:
                        if "age" not in kwargs:
                            test_desc += f", country='{kwargs['country']}'"
                        else:
                            test_desc += f", '{kwargs['country']}'"
                    test_desc += ")"
                    
                    output_lines.append(f"Test Case {passed + failed + 1}: {test_desc} - Failed")
                    output_lines.append(f"   Output: '{result}'")
                    output_lines.append(f"   Expected: '{expected}'")
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
# def create_profile(name, age=18, country='Unknown'):
#     return f'Name: {name}, Age: {age}, Country: {country}'