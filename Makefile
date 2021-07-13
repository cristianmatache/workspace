SHELL := /bin/bash
MAKEFLAGS += -j4

# Aliases
iqor=app_iqor/
utils=lib_py_utils/py_utils lib_py_utils/test_utils

# Targets - for formatting, linting, type-checking, testing
ONPY=algo/ iqor app_paper_plane/ utils lib_bzl_utils/
ONSH=build-support/ deploy-support/ lib_sh_utils/
ONHS=tutorials_hs/scheme_interpreter
ONNB=notebooks/
ONMD=*.md app_* lib_* resources/
ONYML=.ci-azure/ build-support/ deploy-support/ .pre-commit-config.yaml

# Targets - for packaging (e.g. generation of requirements.txt files)
PY_LIBS=lib_py_utils/  # can be pip-install-ed
PY_APPS=app_paper_plane/ app_iqor/  # cannot be pip-installed
PY_PROJECTS=$(PY_LIBS) $(PY_APPS)
PY_LIB_NAMES=$(foreach path,$(utils),$(shell dirname $(path)))  # to be able to pip uninstall

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
include build-support/make/python/pre-commit.mk

# Notebooks
include build-support/make/jupyter/format.mk
include build-support/make/jupyter/lint.mk

# Bash
include build-support/make/bash/setup.mk
include build-support/make/bash/config.mk
include build-support/make/bash/format.mk
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
# Alertmanager YAML
include build-support/make/alertmanager/lint.mk

# Markdown
include build-support/make/markdown/setup.mk
include build-support/make/markdown/config.mk
include build-support/make/markdown/format.mk
include build-support/make/markdown/lint.mk

# BUILD tools
env: env-py env-sh env-md

fmt: fmt-py fmt-nb fmt-yml fmt-md fmt-sh

fmt-check: fmt-check-py fmt-check-nb

lint: lint-py lint-sh lint-nb lint-yml lint-md lint-prometheus lint-alertmanager # lint-hs

type-check: mypy

test: test-py test-sh

clean: clean-py clean-hs

# DEPLOY tools
restartall: restart-airflow restart-prometheus restart-grafana restart-alertmanager

killall: kill-airflow kill-prometheus kill-grafana kill-alertmanager

restart-%:
	$(eval logdir := ./)
	$(eval servicename := $(subst restart-,,$@))
	mkdir -p $(logdir)/logs/$(servicename)
	nohup ./deploy-support/$(servicename)/restart.sh &>> $(logdir)/logs/$(servicename)/$(shell date --iso).txt &

kill-%:
	$(eval servicename := $(subst kill-,,$@))
	./deploy-support/$(servicename)/kill.sh


# OTHER ----------------------------------------------------------------------------------------------------------------
# Run as `make pre-commit since=--cached`
pre-commit: mypy lint pre-commit-tool

rm-envs:
	rm -rf 3rdparty/md-env-ws/node_modules/ 3rdparty/sh-env-ws/node_modules/
