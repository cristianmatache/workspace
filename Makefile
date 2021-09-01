SHELL := /bin/bash
MAKEFLAGS += -j4

# PYTHONPATH
PY_SOURCES_ROOTS=app_iqor:app_paper_plane:lib_py_utils

# Aliases
iqor=app_iqor/
utils=lib_py_utils/py_utils lib_py_utils/test_utils
gen_script=build-support/python/packaging/generate_pip_install_files.py

# Targets - for formatting, linting, type-checking, testing
ONPY=algo/ iqor app_paper_plane/ utils lib_bzl_utils/ gen_script
ONSH=build-support/ deploy-support/ lib_sh_utils/
ONHS=tutorials_hs/scheme_interpreter
ONNB=notebooks/
ONMD=*.md app_* lib_* resources/
ONYML=.ci-azure/ build-support/ deploy-support/ .pre-commit-config.yaml

# Targets - for packaging (e.g. generation of requirements.txt files)
PY_LIBS=lib_py_utils/  # can be pip-install-ed
PY_APPS=app_paper_plane/ app_iqor/  # cannot be pip-installed
PY_PROJECTS=$(PY_LIBS) $(PY_APPS)
PY_LIB_NAMES=$(foreach path,$(utils),$(shell basename $(path)))  # to be able to pip uninstall

# Because some rules may be long, I decided to separate the Makefile in several smaller files.
# It is recommended to keep everything "nested" rules in a single file if possible.

include build-support/make/core/targets.mk  # Utilities to resolve targets

# Bash
include build-support/make/config/bash.mk
include build-support/make/core/bash/setup.mk
include build-support/make/core/bash/format.mk
include build-support/make/core/bash/lint.mk
include build-support/make/core/bash/test.mk

fmt-sh: shfmt
lint-sh: shellcheck shfmt-check
test-sh: bats

# Python
include build-support/make/config/python.mk
include build-support/make/core/python/setup.mk
include build-support/make/extensions/python/setup.mk
include build-support/make/core/python/format.mk
include build-support/make/core/python/lint.mk
include build-support/make/core/python/type-check.mk
include build-support/make/core/python/test.mk
include build-support/make/core/python/package.mk
include build-support/make/core/python/clean.mk
include build-support/make/extensions/python/clean.mk
include build-support/make/core/python/pre-commit.mk

fmt-py: docformatter isort autoflake black flynt
fmt-check-py: autoflake-check docformatter-check isort-check black-check flynt-check
lint-py: mypy flake8 bandit fmt-check-py pylint
test-py: pytest
clean-py: clean-pyc clean-mypy clean-pytest clean-egg-info clean-build-utils

# Notebooks
include build-support/make/config/jupyter.mk
include build-support/make/core/jupyter/format.mk
include build-support/make/core/jupyter/lint.mk

fmt-nb: nbstripout jblack
fmt-check-nb: jblack-check
lint-nb: flake8-nb fmt-check-nb

# Haskell
include build-support/make/core/haskell/lint.mk
include build-support/make/core/haskell/clean.mk

lint-hs: hlint
clean-hs: clean-hio

# YAML
include build-support/make/config/yaml.mk
include build-support/make/core/yaml/format.mk
include build-support/make/core/yaml/lint.mk
# Prometheus YAML
include build-support/make/extensions/prometheus/lint.mk
# Alertmanager YAML
include build-support/make/extensions/alertmanager/lint.mk

fmt-yml: dos2unix-yml
lint-yml: yamllint
lint-prometheus: promtool-check-rules
lint-alertmanager: amtool-check-config

# Markdown
include build-support/make/config/markdown.mk
include build-support/make/core/markdown/setup.mk
include build-support/make/core/markdown/format.mk
include build-support/make/core/markdown/lint.mk

fmt-md: markdownlint-fmt
lint-md: markdownlint

# Cross-language BUILD goals
env-default-replicate: env-py-default-replicate env-sh-default-replicate env-md-default-replicate
env-default-upgrade: env-py-default-upgrade env-sh-default-upgrade env-md-default-upgrade

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
pre-commit: lint pre-commit-tool

rm-envs:
	rm -rf 3rdparty/md-env-ws/node_modules/ 3rdparty/sh-env-ws/node_modules/
