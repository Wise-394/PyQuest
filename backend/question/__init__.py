import importlib
import pkgutil
from pathlib import Path

routers = []

package_dir = Path(__file__).parent

for (_, module_name, _) in pkgutil.iter_modules([str(package_dir)]):
    module = importlib.import_module(f".{module_name}", package=__name__)
    if hasattr(module, "router"):
        routers.append(module.router)
