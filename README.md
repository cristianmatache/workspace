# Workspace
A monorepo containing some of my small projects powered by a scalable build system. See individual README.md files for more details.

[![Build Status](https://dev.azure.com/cristianmatache/workspace/_apis/build/status/cristianmatache.workspace?branchName=master)](https://dev.azure.com/cristianmatache/workspace/_build/latest?definitionId=1&branchName=master)
[![Python 3.8+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![Checked with mypy](http://www.mypy-lang.org/static/mypy_badge.svg)](http://mypy-lang.org/)
![pylint Score](https://mperlet.github.io/pybadge/badges/10.svg)

## Contents:
- **build-support:** Makefile library inspired by Pants/Bazel to run linters, formatters, test frameworks,
  type checkers, packers etc. on a variety of languages (Python, Jupyter Notebooks, Bash, Haskell) → make
- **app_iqor:** IQOR = I Quit Ordinary Renting (HackZurich 2019) →  Q/KDB+Python
- **app_paper_plane:** Paper Plane = find same flight but cheaper by changing country on Skyscanner (LauzHack 2018) → Python
- **dotfiles:** my take-everywhere rc-files
- **lib_bzl_utils:** useful macros for Bazel →  Starlark
- **lib_py_utils:** a few interesting general purpose utility functions → Python
- **tutorials_hs:**
  - h99: see https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems → Haskell
  - scheme interpreter: see https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours → Haskell
- **tutorials_q:**
  - weekly_q: see https://dpkwhan.github.io/weeklyq/ → Q/KDB

## Hackathon projects:
For more hackathon projects see my devpost accounts:
-  https://devpost.com/crm15
-  https://devpost.com/cristianmatache

Some projects will be ported over here, some others are lost somewhere in space and time.

## Makefile for scripting languages
The way the Makefile of this project works is heavily inspired by monorepo build tools such as Pants, Bazel, Buck.
It runs multiple linters, formatters, type checkers, hermetic packers, testing frameworks etc. It works on both 
Linux, WSL and Windows (for Windows please run  `build-support/make/install_make_git_bash.sh` running Git Bash as administrator)
It currently supports:
`mypy`, `flake8`, `pylint`, `bandit`, `docformatter`, `isort`, `autoflake`, `pipreqs`, `shiv`, `jupyterblack`, `flake8-nb`, `shellcheck`, `hlint`;
and it would be very easy to extend it with another tool, just following the existing examples.

### Usage examples:
-  **with no targets:**
  -  `make lint` runs:
    -  a bunch of python linters on all directories (in `$onpy`) that contain python/stub files.
    -  a bunch of notebook linters on all directories (in `$onnb`) that contain .ipynb files.
    -  a bash linter (shellcheck) on all directories (in `$onsh`) that contain bash files.
    -  a haskell linter (shellcheck) on all directories (in `$onhs`) that contain haskell files.
  -  same for `make fmt`, `make test`, `make type-check`
-  **with nominal targets:**
    -  `make lint on=app_iqor/server.py` runs all python linters on the file, same as `make lint-py on=app_iqor/server.py`
    -  `make lint on=lib_py_utils` runs a bunch of linters on the directory, in this case, same as `make lint-py on=lib_py_utils`
    -  same for `make fmt`, `make test`, `make type-check`
- **with aliases:**
    -  `make fmt on=iqor` is the same as `make fmt on=app_iqor/` because iqor is an alias for app_iqor.
       Even though this example is simplistic, it is useful to alias combinations of multiple files/directories.
-  **with revision targets:**
    -  `make fmt -j1 since=master` runs all formatters on the diff between the current branch and master.
    -  `make fmt -j1 since=HEAD~1` runs all formatters on all files that changed since "2 commits ago".
-  **with specific tools:**
      -  `make mypy` runs mypy on `$onpy`.
      -  `make mypy on=app_iqor/server.py` runs mypy on the given file.
      -  `make mypy since=master` runs mypy on the diff between the current branch and master.
      -  same for all tools e.g. isort, docformatter, autoflake, shellcheck, flake8, jblack etc.
  
To add things on the PYTHONPATH (i.e. to mark directories as sources roots) go to build-support/make/python/setup.py
Different languages have different goals, for example Python can be packaged hermetically with Shiv, while Bash can't
obviously.

The following goals must support the "on" and "since" syntax and ensure that they are only run if there are any
targets for the language they target:
-  format
-  lint
-  type-check
-  test
