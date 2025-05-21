# -*- coding: utf-8 -*-
"""
Copyright 2024 mROS 2 for PlatformIO

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import json
from pathlib import Path
Import("env")


# Install missed package
try:
    import jinja2
except ImportError or ModuleNotFoundError:
    env.Execute("${PYTHONEXE} -m pip install jinja2")


def get_library_name():
    with open("library.json", 'r', encoding='utf-8') as f:
        library_data = json.load(f)
        library_name = library_data["name"]

    return library_name


def run_cmake_config():
    platform = env.PioPlatform()
    src_dir = "."
    build_dir = Path(env.get("PROJECT_BUILD_DIR"), env.get(
        "PIOENV"), get_library_name(), "build")

    if not platform.get_package_dir("tool-cmake"):
        platform.install_package("tool-cmake")
    if not platform.get_package_dir("tool-ninja"):
        platform.install_package("tool-ninja")

    cmd = [
        Path(platform.get_package_dir("tool-cmake"),
             "bin", "cmake").resolve().as_posix(),
        "--fresh",
        "-S", Path(src_dir).resolve().as_posix(),
        "-B", Path(build_dir).resolve().as_posix(),
        "-G", "Ninja",
        "-DMROS2_PLATFORM=espressif32",
        "-DPIOLIB=1",
    ]

    env.Execute(" ".join(cmd))


def generate_header():
    p = Path(env.get("PROJECT_BUILD_DIR"), env.get(
        "PIOENV"), get_library_name(), "generate")
    if not p.exists() or not p.is_dir():
        p.mkdir(parents=True)

    cmd = [
        env.get("PYTHONEXE"),
        Path("mros2/mros2_header_generator/templates_generator.py").resolve().as_posix(),
        "--outdir", p.resolve().as_posix(),
        "--indir", Path(env.get("PROJECT_DIR"), "src").resolve().as_posix()
    ]

    env.Execute(" ".join(cmd))
    env.AppendUnique(CPPPATH=p.resolve().as_posix())


def update_env():
    # Define the filename for the list of source filter rules.
    source_paths_file = Path(env.get("PROJECT_BUILD_DIR"), env.get(
        "PIOENV"), get_library_name(), "build", "mros2_source_list.txt")
    # Define the filename for the list of include directories.
    include_dirs_file = Path(env.get("PROJECT_BUILD_DIR"), env.get(
        "PIOENV"), get_library_name(), "build", "mros2_include_list.txt")

    # Process source filter from source paths
    env.Append(SRC_FILTER=f"-<{Path('.')}>")
    with open(source_paths_file, "r") as f:
        source_paths = [line.strip() for line in f if line.strip()]

    if source_paths:
        # Append the generated filter rules to the SRC_FILTER in the build environment.
        env.Append(SRC_FILTER=[f"+<{path}>" for path in source_paths])
    else:
        print("Source file list is empty.")

    # Process include directories
    with open(include_dirs_file, "r") as f:
        include_dirs = [line.strip() for line in f if line.strip()]

    if include_dirs:
        # Append the loaded include directories to the CPATH (C/C++ Path) in the build environment.
        env.AppendUnique(CPPPATH=[Path(i).resolve().as_posix()
                         for i in include_dirs])
    else:
        print("Include directory list is empty.")


generate_header()
run_cmake_config()
update_env()
