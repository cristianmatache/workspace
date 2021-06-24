# Workspace

A monorepo containing some of my small projects powered by a scalable build system. See individual README.md files for
more details.

[![Build Status](https://dev.azure.com/cristianmatache/workspace/_apis/build/status/cristianmatache.workspace?branchName=master)](https://dev.azure.com/cristianmatache/workspace/_build/latest?definitionId=1&branchName=master)
[![Python 3.8+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![Checked with mypy](http://www.mypy-lang.org/static/mypy_badge.svg)](http://mypy-lang.org/)
![pylint Score](https://mperlet.github.io/pybadge/badges/10.svg)

## Contents

- **build-support:** Makefile library inspired by Pants/Bazel to run linters, formatters, test frameworks, type
  checkers, packers etc. on a variety of languages (Python, Jupyter Notebooks, Bash, Haskell, YAML, Markdown) → make
- **app_iqor:** IQOR = I Quit Ordinary Renting (HackZurich 2019) → Q/KDB+Python
- **app_paper_plane:** Paper Plane = find same flight but cheaper by changing country on Skyscanner (LauzHack 2018) →
  Python
- **dotfiles:** my take-everywhere rc-files
- **lib_bzl_utils:** useful macros for Bazel → Starlark
- **lib_py_utils:** a few interesting general purpose utility functions → Python
- **tutorials_hs:**
  - h99: see <https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems> → Haskell
  - scheme interpreter: see <https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours> → Haskell
- **tutorials_q:**
  - weekly_q: see <https://dpkwhan.github.io/weeklyq/> → Q/KDB

## Hackathon projects

For more hackathon projects see my devpost accounts:

- <https://devpost.com/crm15>
- <https://devpost.com/cristianmatache>

Some projects will be ported over here, some others are lost somewhere in space and time.

## Makefile (mainly for scripting and config languages)

The way the Makefile of this project works draws inspiration heavily from monorepo build tools such as Pants, Bazel,
Buck. It runs multiple linters, formatters, type checkers, hermetic packers, testing frameworks, virtual environment
managers etc. It works on Linux, WSL and Windows with Git Bash (for Windows please
run  `build-support/git-bash-integration/install_make.sh` running Git Bash as administrator)
It currently supports:

- Python: `pip`, `mypy`, `pytest`, `flake8`, `pylint`, `bandit`, `black`, `docformatter`, `isort`, `autoflake`,
  `pipreqs`, `shiv`
- Jupyter: `flake8-nb`, `jupyterblack`, `nbstripout`
- Bash: `shellcheck`, `bats` (bash testing: `bats-core`, `bats-assert`, `bats-support`)
- Haskell: `hlint`
- YAML: `yamllint`
  - Prometheus YAML: `promtool check`

and it would be very easy to extend it with another tool, just following the existing examples.

These tools may be run individually (e.g. `make mypy`) or altogether by a more general rule. For example:

- format (e.g. `make fmt`, `make fmt-py`, `make fmt-yml`) - runs all formatters for all/a specific language
- lint (e.g. `make lint`, `make lint-py`, `make lint-sh`, `make lint-yml`) - runs all linters for all/a specific
  language, these usually include checks whether the `fmt` command was run
- test (e.g. `make test-py`, `make test-sh`)

### Usage examples

- **without targets:**
  - `make lint` runs:
    - a bunch of Python linters on all directories (in `$onpy`) that contain python/stub files.
    - a bunch of notebook linters on all directories (in `$onnb`) that contain .ipynb files.
    - a Bash linter (shellcheck) on all directories (in `$onsh`) that contain Bash files.
    - a Haskell linter (hlint) on all directories (in `$onhs`) that contain Haskell files.
    - a YAML linter (yamllint) on all directories (in `$onyml`) that contain YAML files.
  - `make lint`, `make fmt -j1`, `make type-check` work similarly
  - the `$(onpy)`, `$(onsh)`, ... variables are defined at the top of the Makefile and represent the default locations
      where to search for certain languages.
  - per-tool config files (e.g. `mypy.ini`) are found in `build-support/<language>/tools-config/`
- **per language:**
  Instead of running all linters for all languages, you may often want to run all linters for a specific programming
  language.
  - `make lint-py` runs all Python linters over all Python targets (as specified by `$onpy`). because our target is a
      single python file.
  - `make fmt-py`, `make lint-sh`, `make lint-hs`, `make lint-yml`, `make fmt-yml`
- **with nominal targets:**
  - `make lint on=app_iqor/server.py` runs all Python linters on the file, same
      as `make lint-py on=app_iqor/server.py`
  - `make lint on=lib_py_utils` runs a bunch of linters on the directory, in this case, same
      as `make lint-py on=lib_py_utils`.
  - `make lint on="lib_py_utils app_iqor/server.py"` runs a bunch of linters on both targets.
  - same for `make fmt`, `make test`, `make type-check`.
- **with aliases:**
  - `make fmt on=iqor` is the same as `make fmt on=app_iqor/` because iqor is an alias for app_iqor. Even though this
      example is simplistic, it is useful to alias combinations of multiple files/directories. It is recommended to set
      aliases as constants in the Makefile even though environment variables would also work.
- **with revision targets:**
  - `make fmt -j1 since=master` runs all formatters on the diff between the current branch and master.
  - `make fmt -j1 since=HEAD~1` runs all formatters on all files that changed since "2 commits ago".
- **with specific tools:**
  - `make mypy` runs mypy on `$onpy`.
  - `make mypy on=app_iqor/server.py` runs mypy on the given file.
  - `make mypy since=master` runs mypy on the diff between the current branch and master.
  - same for all tools e.g. isort, docformatter, autoflake, shellcheck, flake8, jblack etc.
- **with multiple rules:**
  - `make lint-py mypy lint-sh lint-md on=app_iqor/` runs all Python linters, mypy, shellcheck, markdownlint on
    `app_iqor/`.

To add things on the PYTHONPATH (i.e. to mark directories as sources roots) go to build-support/make/python/setup.py
Different languages have different goals, for example Python can be packaged hermetically with Shiv, while Bash
obviously can't.

The following goals must support the "on" and "since" syntax and ensure that they are only run if there are any targets
for the language they target:

- format
- lint
- type-check
- test

If you want to learn more about the API of a specific rule, check the source code.

### Installation

To add this build system to an existing repo, one needs to simply copy `build-support/` and `3rdparty/` over.
Run `make env`, as a one-off, to set up the python, markdown and bash environments (mostly pip/npm install-s). It is
recommended to copy over `lib_sh_utils/` and `deploy-support/` if you need support for Prometheus, Alertmanager or
Grafana. In addition, if renaming directories in `3rdparty` the correspondent paths in
`build-support/make/<lang>/setup.mk` and/or `build-support/make/<lang>/config.mk` should also be updated.
