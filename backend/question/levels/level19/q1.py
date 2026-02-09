from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/19/question/1")
def get_question():
    return {
        "question": (
            "🎮 Game Inventory\n"
            "Create a class 'Inventory' to store game items in a list!\n"
            "Requirements:\n"
            "• __init__: Create an empty list called 'items'\n"
            "• add_item(item): Add an item to the list\n"
            "• count_items(): Return how many items are in the list\n\n"
            "Example 1:\n"
            "Input: inv = Inventory()\n"
            "       inv.add_item('Sword')\n"
            "       inv.add_item('Shield')\n"
            "       inv.count_items()\n"
            "Output: 2\n\n"
            "Example 2:\n"
            "Input: inv = Inventory()\n"
            "       inv.add_item('Potion')\n"
            "       inv.count_items()\n"
            "Output: 1\n\n"
            "Example 3:\n"
            "Input: inv = Inventory()\n"
            "       inv.count_items()\n"
            "Output: 0\n\n"
            "Hint: Use self.items = [] and .append()!"
        ),
        "code": ""
    }

@router.post("/level/19/question/1")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Your First Class with a List![/b]\n\n"
        "[b]Solution:[/b]\n"
        "[color=red]class Inventory:[/color]\n"
        "[color=red]    def __init__(self):[/color]\n"
        "[color=red]        self.items = []  # Empty list[/color]\n\n"
        "[color=red]    def add_item(self, item):[/color]\n"
        "[color=red]        self.items.append(item)[/color]\n\n"
        "[color=red]    def count_items(self):[/color]\n"
        "[color=red]        return len(self.items)[/color]\n\n"
        "[b]What's happening?[/b]\n"
        "• [color=cyan]self.items = [][/color] - Makes an empty list\n"
        "• [color=cyan].append(item)[/color] - Adds item to the list\n"
        "• [color=cyan]len(self.items)[/color] - Counts items in list\n\n"
        "[color=yellow]🎮 Tip:[/color] Lists can hold many items, just like a real inventory!"
    )
    
    # Check if class is defined
    if "class Inventory" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Class 'Inventory' is not defined.\n"
                "Start with: class Inventory:"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    required_methods = ["__init__", "add_item", "count_items"]
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
        
        if "Inventory" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Class 'Inventory' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        Inventory = exec_globals["Inventory"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        # Test Case 1: Empty inventory count
        try:
            inv = Inventory()
            result = inv.count_items()
            expected = 0
            if result == expected:
                output_lines.append(f"Test 1: Empty inventory count = {result} ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 1: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 1: Error - {str(e)}")
            failed += 1
        
        # Test Case 2: Add one item
        try:
            inv = Inventory()
            inv.add_item("Sword")
            result = inv.count_items()
            expected = 1
            if result == expected:
                output_lines.append(f"Test 2: After adding 1 item, count = {result} ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 2: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 2: Error - {str(e)}")
            failed += 1
        
        # Test Case 3: Add multiple items
        try:
            inv = Inventory()
            inv.add_item("Helmet")
            inv.add_item("Shield")
            inv.add_item("Potion")
            result = inv.count_items()
            expected = 3
            if result == expected:
                output_lines.append(f"Test 3: After adding 3 items, count = {result} ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 3: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 3: Error - {str(e)}")
            failed += 1
        
        # Test Case 4: Check items list exists
        try:
            inv = Inventory()
            inv.add_item("Axe")
            inv.add_item("Bow")
            if hasattr(inv, 'items') and "Axe" in inv.items and "Bow" in inv.items:
                output_lines.append(f"Test 4: Items stored correctly in list ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 4: Items not stored correctly - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 4: Error - {str(e)}")
            failed += 1
        
        total_tests = 4
        output_lines.append(f"\nTest Results: {passed}/{total_tests} passed")
        
        if passed == total_tests:
            output_lines.append("\n🎉 Perfect! Your inventory system works!")
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
# class Inventory:
#     def __init__(self):
#         self.items = []
#     
#     def add_item(self, item):
#         self.items.append(item)
#     
#     def count_items(self):
#         return len(self.items)