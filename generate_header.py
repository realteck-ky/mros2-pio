Import("env")

import pathlib

# Install missed package
try:
    import jinja2
except ImportError or ModuleNotFoundError:
    env.Execute("${PYTHONEXE} -m pip install jinja2")

p = pathlib.Path("generate")
if not p.exists() or not p.is_dir():
    p.mkdir()

env.Execute("${PYTHONEXE} mros2/mros2_header_generator/templates_generator.py " +
            "--outdir " + p.name + " --indir ${PROJECT_DIR}/src")
