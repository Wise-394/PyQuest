from fastapi import APIRouter
from pydantic import BaseModel
from execute_code import execute_user_code

router = APIRouter()

class UserCodeRequest(BaseModel):
    user_code: str
    question_id: int

@router.get("/level/19/question/3")
def get_question():
    return {
        "question": (
            "🏆 Game Score Tracker\n"
            "Create a class 'ScoreTracker' to track player scores!\n"
            "Requirements:\n"
            "• __init__: Create an empty list called 'scores'\n"
            "• add_score(score): Add a score to the list\n"
            "• get_total(): Return the sum of all scores\n"
            "• get_average(): Return the average of all scores\n"
            "  - If no scores, return 0\n"
            "• get_highest(): Return the highest score\n"
            "  - If no scores, return 0\n\n"
            "Example 1:\n"
            "Input: st = ScoreTracker()\n"
            "       st.add_score(100)\n"
            "       st.add_score(200)\n"
            "       st.get_total()\n"
            "Output: 300\n\n"
            "Example 2:\n"
            "Input: st = ScoreTracker()\n"
            "       st.add_score(50)\n"
            "       st.add_score(70)\n"
            "       st.get_average()\n"
            "Output: 60.0\n\n"
            "Example 3:\n"
            "Input: st = ScoreTracker()\n"
            "       st.add_score(10)\n"
            "       st.add_score(30)\n"
            "       st.add_score(20)\n"
            "       st.get_highest()\n"
            "Output: 30\n\n"
            "Hint: Use a for loop to add up scores!"
        ),
        "code": ""
    }

@router.post("/level/19/question/3")
def post_user_code(request: UserCodeRequest):
    explanation = (
        "[b]🎯 Score System with Loops![/b]\n\n"
        "[b]Solution:[/b]\n"
        "[color=red]class ScoreTracker:[/color]\n"
        "[color=red]    def __init__(self):[/color]\n"
        "[color=red]        self.scores = [][/color]\n\n"
        "[color=red]    def add_score(self, score):[/color]\n"
        "[color=red]        self.scores.append(score)[/color]\n\n"
        "[color=red]    def get_total(self):[/color]\n"
        "[color=red]        total = 0[/color]\n"
        "[color=red]        for score in self.scores:[/color]\n"
        "[color=red]            total += score[/color]\n"
        "[color=red]        return total[/color]\n\n"
        "[color=red]    def get_average(self):[/color]\n"
        "[color=red]        if len(self.scores) == 0:[/color]\n"
        "[color=red]            return 0[/color]\n"
        "[color=red]        return self.get_total() / len(self.scores)[/color]\n\n"
        "[color=red]    def get_highest(self):[/color]\n"
        "[color=red]        if len(self.scores) == 0:[/color]\n"
        "[color=red]            return 0[/color]\n"
        "[color=red]        return max(self.scores)[/color]\n\n"
        "[b]What's happening?[/b]\n"
        "• [color=cyan]for score in self.scores:[/color] - Loop through list\n"
        "• [color=cyan]total += score[/color] - Add each score\n"
        "• [color=cyan]max(self.scores)[/color] - Find biggest number\n"
        "• [color=cyan]total / len(scores)[/color] - Calculate average\n\n"
        "[color=yellow]🎮 Tip:[/color] Use loops to process all items in a list!"
    )
    
    # Check if class is defined
    if "class ScoreTracker" not in request.user_code:
        return {
            "status": "success",
            "output": (
                "Error: Class 'ScoreTracker' is not defined.\n"
                "Start with: class ScoreTracker:"
            ),
            "is_correct": False,
            "explanation": explanation
        }
    
    required_methods = ["__init__", "add_score", "get_total", "get_average", "get_highest"]
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
        
        if "ScoreTracker" not in exec_globals:
            return {
                "status": "success",
                "output": "Error: Class 'ScoreTracker' not found in your code.",
                "is_correct": False,
                "explanation": explanation
            }
        
        ScoreTracker = exec_globals["ScoreTracker"]
        
        # Run test cases
        passed = 0
        failed = 0
        output_lines = ["Running test cases...\n"]
        
        # Test Case 1: Get total
        try:
            st = ScoreTracker()
            st.add_score(100)
            st.add_score(200)
            result = st.get_total()
            expected = 300
            if result == expected:
                output_lines.append(f"Test 1: Total of scores (100 + 200 = 300) ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 1: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 1: Error - {str(e)}")
            failed += 1
        
        # Test Case 2: Get average
        try:
            st = ScoreTracker()
            st.add_score(50)
            st.add_score(70)
            result = st.get_average()
            expected = 60.0
            if result == expected:
                output_lines.append(f"Test 2: Average of scores (60.0) ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 2: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 2: Error - {str(e)}")
            failed += 1
        
        # Test Case 3: Get highest
        try:
            st = ScoreTracker()
            st.add_score(10)
            st.add_score(30)
            st.add_score(20)
            result = st.get_highest()
            expected = 30
            if result == expected:
                output_lines.append(f"Test 3: Highest score (30) ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 3: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 3: Error - {str(e)}")
            failed += 1
        
        # Test Case 4: Empty list - average
        try:
            st = ScoreTracker()
            result = st.get_average()
            expected = 0
            if result == expected:
                output_lines.append(f"Test 4: Empty list average = 0 ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 4: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 4: Error - {str(e)}")
            failed += 1
        
        # Test Case 5: Empty list - highest
        try:
            st = ScoreTracker()
            result = st.get_highest()
            expected = 0
            if result == expected:
                output_lines.append(f"Test 5: Empty list highest = 0 ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 5: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 5: Error - {str(e)}")
            failed += 1
        
        # Test Case 6: Multiple scores
        try:
            st = ScoreTracker()
            st.add_score(80)
            st.add_score(90)
            st.add_score(85)
            st.add_score(95)
            result = st.get_total()
            expected = 350
            if result == expected:
                output_lines.append(f"Test 6: Total of 4 scores (350) ✓ Passed")
                passed += 1
            else:
                output_lines.append(f"Test 6: Got {result}, expected {expected} - Failed")
                failed += 1
        except Exception as e:
            output_lines.append(f"Test 6: Error - {str(e)}")
            failed += 1
        
        total_tests = 6
        output_lines.append(f"\nTest Results: {passed}/{total_tests} passed")
        
        if passed == total_tests:
            output_lines.append("\n🎉 Excellent! Your score tracker works perfectly!")
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
# class ScoreTracker:
#     def __init__(self):
#         self.scores = []
#     
#     def add_score(self, score):
#         self.scores.append(score)
#     
#     def get_total(self):
#         total = 0
#         for score in self.scores:
#             total += score
#         return total
#     
#     def get_average(self):
#         if len(self.scores) == 0:
#             return 0
#         return self.get_total() / len(self.scores)
#     
#     def get_highest(self):
#         if len(self.scores) == 0:
#             return 0
#         return max(self.scores)