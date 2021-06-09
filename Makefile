SHELL := /bin/bash
MAKEFLAGS += -j4

# Aliases
iqor=app_iqor/ 

# All projects
onpy=algo/ iqor app_paper_plane/ lib_py_utils/ lib_bzl_utils/
onhs=tutorials_hs/scheme_interpreter
onsh=build-support/ deploy-support/ lib_sh_utils/
onnb=notebooks/
onyml=.ci-azure/ build-support/ deploy-support/
onmd=*.md app_* lib_* resources/

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
include build-support/make/bash/setup.mk
include build-support/make/bash/config.mk
include build-support/make/bash/lint.mk
include build-support/make/bash/test.mk

# Haskell
include build-support/make/haskell/lint.mk
include build-support/make/haskell/clean.mk

# YAML
include build-support/make/yaml/config.mk
include build-support/make/yaml/format.mk
include build-support/make/yaml/lint.mk
# Prometheus YAML
include build-support/make/prometheus/lint.mk

# Markdown
include build-support/make/markdown/setup.mk
include build-support/make/markdown/config.mk
include build-support/make/markdown/format.mk
include build-support/make/markdown/lint.mk

# Airflow
include deploy-support/make/airflow.mk


env: env-py env-sh env-md

fmt: fmt-py fmt-nb fmt-yml fmt-md

lint: lint-py lint-sh lint-nb lint-yml lint-prometheus lint-md # lint-hs

type-check: mypy

test: test-py test-sh

clean: clean-py clean-hs


# OTHER ----------------------------------------------------------------------------------------------------------------
pre-commit: mypy lint

rm-envs:
	rm -rf 3rdparty/md-env-ws/node_modules/ 3rdparty/sh-env-ws/node_modules/
