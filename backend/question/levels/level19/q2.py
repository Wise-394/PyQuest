from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/19/question/2")
def get_question():
    return {
        "question": (
            "⚔️ Simple Hero Class\n"
            "Create a class 'Hero' with health tracking!\n"
            "Requirements:\n"
            "• __init__(name, health): Save the hero's name and health\n"
            "• is_alive(): Return True if health > 0, else False\n"
            "• heal(amount): Add amount to health\n"
            "• take_damage(amount): Subtract amount from health\n"
            "  - Health cannot go below 0\n\n"
            "Example 1:\n"
            "Input: hero = Hero('Link', 100)\n"
            "       hero.is_alive()\n"
            "Output: True\n\n"
            "Example 2:\n"
            "Input: hero = Hero('Mario', 50)\n"
            "       hero.heal(20)\n"
            "       hero.health\n"
            "Output: 70\n\n"
            "Example 3:\n"
            "Input: hero = Hero('Cloud', 30)\n"
            "       hero.take_damage(50)\n"
            "       hero.health\n"
            "Output: 0  # Can't go below 0!\n\n"
            "Hint: Use if statements to check health!"
        ),
        "code": ""
    }

@router.post("/level/19/question/2")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Hero Health System![/b]\n\n"
        "[b]Solution:[/b]\n"
        "[color=red]class Hero:[/color]\n"
        "[color=red]    def __init__(self, name, health):[/color]\n"
        "[color=red]        self.name = name[/color]\n"
        "[color=red]        self.health = health[/color]\n\n"
        "[color=red]    def is_alive(self):[/color]\n"
        "[color=red]        return self.health > 0[/color]\n\n"
        "[color=red]    def heal(self, amount):[/color]\n"
        "[color=red]        self.health += amount[/color]\n\n"
        "[color=red]    def take_damage(self, amount):[/color]\n"
        "[color=red]        self.health -= amount[/color]\n"
        "[color=red]        if self.health < 0:[/color]\n"
        "[color=red]            self.health = 0[/color]\n\n"
        "[b]What's happening?[/b]\n"
        "• [color=cyan]self.health += amount[/color] - Add to health\n"
        "• [color=cyan]self.health -= amount[/color] - Subtract from health\n"
        "• [color=cyan]if self.health < 0:[/color] - Check if negative\n"
        "• [color=cyan]return self.health > 0[/color] - True/False check\n\n"
        "[color=yellow]🎮 Tip:[/color] Always check if health goes below 0!"
    )
    
    # Check if class is defined
    if "class Hero" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Class 'Hero' is not defined.\n"
                "Start with: class Hero:"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    required_methods = ["__init__", "is_alive", "heal", "take_damage"]
    for method in required_methods:
        if f"def {method}" not in request.user_code:
            return {
                "status": "success",
                "output": f"Error: Missing '{method}' method.",
                "is_correct": False,
                "explanation": explanation
            }
    
    try:
        # Execute user code to define the class
        exec_globals = {}
        exec(request.user_code, exec_globals)
        
        if "Hero" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Class 'Hero' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        Hero = exec_globals["Hero"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        # Test Case 1: Is alive (true)
        try:
            hero = Hero("Link", 100)
            result = hero.is_alive()
            expected = True
            if result == expected:
                output_lines.append(f"Test 1: Hero with 100 health is alive ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 1: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 1: Error - {str(e)}")
            failed += 1
        
        # Test Case 2: Is alive (false)
        try:
            hero = Hero("Ghost", 0)
            result = hero.is_alive()
            expected = False
            if result == expected:
                output_lines.append(f"Test 2: Hero with 0 health is not alive ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 2: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 2: Error - {str(e)}")
            failed += 1
        
        # Test Case 3: Heal
        try:
            hero = Hero("Mario", 50)
            hero.heal(20)
            result = hero.health
            expected = 70
            if result == expected:
                output_lines.append(f"Test 3: Healing works (50 + 20 = 70) ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 3: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 3: Error - {str(e)}")
            failed += 1
        
        # Test Case 4: Take damage (normal)
        try:
            hero = Hero("Cloud", 80)
            hero.take_damage(30)
            result = hero.health
            expected = 50
            if result == expected:
                output_lines.append(f"Test 4: Taking damage works (80 - 30 = 50) ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 4: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 4: Error - {str(e)}")
            failed += 1
        
        # Test Case 5: Health cannot go below 0
        try:
            hero = Hero("Ryu", 30)
            hero.take_damage(50)
            result = hero.health
            expected = 0
            if result == expected:
                output_lines.append(f"Test 5: Health stops at 0 (30 - 50 = 0) ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 5: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 5: Error - {str(e)}")
            failed += 1
        
        total_tests = 5
        output_lines.append(f"\nTest Results: {passed}/{total_tests} passed")
        
        if passed == total_tests:
            output_lines.append("\n🎉 Awesome! Your hero system works great!")
            is_correct = True
        else:
            output_lines.append(f"\n{failed} test case(s) failed. Try again!")
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
# class Hero:
#     def __init__(self, name, health):
#         self.name = name
#         self.health = health
#     
#     def is_alive(self):
#         return self.health > 0
#     
#     def heal(self, amount):
#         self.health += amount
#     
#     def take_damage(self, amount):
#         self.health -= amount
#         if self.health < 0:
#             self.health = 0