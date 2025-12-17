import importlib
import pkgutil
from pathlib import Path

routers = []

# 1. Point to this 'question' folder
package_dir = str(Path(__file__).parent)
package_name = __package__ 

# 2. walk_packages enters every subfolder found in Step 1
for loader, module_name, is_pkg in pkgutil.walk_packages([package_dir], f"{package_name}."):
    try:
        # 3. Import the specific file (e.g., question.levels.level1.q1)
        module = importlib.import_module(module_name)
        
        # 4. If the file has 'router = APIRouter()', add it to our list
        if hasattr(module, "router"):
            routers.append(module.router)
            print(f"✅ Successfully loaded: {module_name}")
            
    except Exception as e:
        print(f"❌ Error loading {module_name}: {e}")