MAKEFLAGS += -j4

# Aliases
iqor=app_iqor/ 

# All projects
onpy=algo/ iqor app_paper_plane/ lib_py_utils/ lib_bzl_utils/
onhs=tutorials_hs/scheme_interpreter
onsh=build-support/
onnb=notebooks/

# Because some rules may be long, I decided to separate the Makefile in several smaller files.
# It is recommended to keep everything in a single file if possible.

include build-support/make/targets.mk  # Utilities to resolve targets

# Python
include build-support/make/python/setup.mk
include build-support/make/python/config.mk
include build-support/make/python/format.mk
include build-support/make/python/lint.mk
include build-support/make/python/type-check.mk
include build-support/make/python/test.mk
include build-support/make/python/package.mk
include build-support/make/python/clean.mk

# Notebooks
include build-support/make/jupyter/format.mk
include build-support/make/jupyter/lint.mk

# Bash
include build-support/make/bash/lint.mk

# Haskell
include build-support/make/haskell/lint.mk
include build-support/make/haskell/clean.mk

# Airflow
include deploy-support/make/airflow.mk

env: env-py

fmt: fmt-py fmt-nb

lint: lint-py lint-sh lint-nb # lint-hs

type-check: mypy

test: test-py

clean: clean-py clean-hs


# OTHER ----------------------------------------------------------------------------------------------------------------
pre-commit: mypy lint
