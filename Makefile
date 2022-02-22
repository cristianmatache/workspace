#This is an example top-level Makefile, inner Makefile-s would work similarly
SHELL := /usr/bin/env bash
# By default run multiple tools sequentially, when formatting  you may want to run "make -j1" to ensure formatters
# run sequentially
MAKEFLAGS += -j1

# resolver.mk and helpers.mk contain the AlphaBuild core logic
# Because some rules may be long, the Makefile is split in several smaller files (they all belong to the same namespace).
# It is recommended to keep all "nested" rules in this file if possible.
include build-support/alpha-build/core/resolver.mk  # Utilities to resolve targets
include build-support/alpha-build/core/helpers.mk

# Set PYTHONPATH
PY_SOURCES_ROOTS=app_iqor:app_paper_plane:lib_py_utils
include build-support/alpha-build/core/python/pythonpath.mk  # Let AlphaBuild set PYTHONPATH based on PY_SOURCES_ROOTS

plm:
	echo "$$PYTHONPATH"

# Aliases (short names given to one or more paths, can be used to define the default targets,)
iqor=app_iqor/
utils=lib_py_utils/py_utils lib_py_utils/test_utils
gen_script=build-support/python/packaging/generate_pip_install_files.py

# Default targets - for formatting, linting, type-checking, testing
ONPY=algo/ iqor app_paper_plane/ utils lib_bzl_utils/ gen_script  # References actual directories and/or aliases
ONSH=build-support/ deploy-support/ lib_sh_utils/
ONHS=tutorials_hs/scheme_interpreter
ONNB=notebooks/
ONMD=*.md app_* lib_* resources/
ONYML=.ci-azure/ build-support/ deploy-support/ .pre-commit-config.yaml
ONHTML=iqor app_paper_plane/
ONCSS=$(ONHTML)

# Config files (i.e., mostly <TOOL>_FLAGS variables, which contain the flags for tools like pytest, mypy etc.)
include build-support/alpha-build/config/bash.mk
include build-support/alpha-build/config/multi.mk
include build-support/alpha-build/config/python.mk
include build-support/alpha-build/config/yaml.mk
include build-support/alpha-build/config/jupyter.mk
include build-support/alpha-build/config/markdown.mk

# Targets - for packaging (e.g. generation of requirements.txt files)
PY_LIBS=lib_py_utils/  # can be pip-install-ed
PY_APPS=app_paper_plane/ app_iqor/  # cannot be pip-installed
PY_PROJECTS=$(PY_LIBS) $(PY_APPS)
PY_LIB_NAMES=$(foreach path,$(PY_PROJECTS),$(shell basename $(path)))  # to be able to pip uninstall

# Bash
include build-support/alpha-build/core/bash/env.mk
include build-support/alpha-build/core/bash/format.mk
include build-support/alpha-build/core/bash/lint.mk
include build-support/alpha-build/core/bash/test.mk

.PHONY: fmt-sh lint-sh test-sh
fmt-sh: shfmt
lint-sh: shellcheck shfmt-check
test-sh: bats

# Multi language
include build-support/alpha-build/core/multi/env.mk

# Python
#export MYPYPATH := $(PYTHONPATH)  # Uncomment to set MYPYPATH to be the same as PYTHONPATH
include build-support/alpha-build/core/python/env.mk
include build-support/alpha-build/extensions/python/setup.mk
include build-support/alpha-build/core/python/format.mk
include build-support/alpha-build/core/python/lint.mk
include build-support/alpha-build/core/python/type-check.mk
include build-support/alpha-build/core/python/test.mk
include build-support/alpha-build/core/python/package.mk
include build-support/alpha-build/core/python/clean.mk
include build-support/alpha-build/extensions/python/clean.mk
include build-support/alpha-build/core/python/pre-commit.mk

.PHONY: fmt-py fmt-check-py lint-py test-py clean-py
fmt-py: docformatter isort autoflake black flynt
fmt-check-py: autoflake-check docformatter-check isort-check black-check flynt-check
lint-py: mypy flake8 bandit fmt-check-py pylint
test-py: pytest
clean-py: clean-pyc clean-mypy clean-pytest clean-egg-info clean-build-utils

# Notebooks
include build-support/alpha-build/core/jupyter/format.mk
include build-support/alpha-build/core/jupyter/lint.mk

.PHONY: fmt-nb fmt-check-nb lint-nb
fmt-nb: nbstripout jblack
fmt-check-nb: jblack-check
lint-nb: flake8-nb fmt-check-nb

# Haskell
include build-support/alpha-build/core/haskell/lint.mk
include build-support/alpha-build/core/haskell/clean.mk

.PHONY: lint-hs clean-hs
lint-hs: hlint
clean-hs: clean-hio

# YAML
include build-support/alpha-build/core/yaml/format.mk
include build-support/alpha-build/core/yaml/lint.mk
# Prometheus YAML
include build-support/alpha-build/extensions/prometheus/lint.mk
# Alertmanager YAML
include build-support/alpha-build/extensions/alertmanager/lint.mk

.PHONY: fmt-yml lint-yml lint-prometheus lint-alertmanager
fmt-yml: prettier-yml
lint-yml: yamllint prettier-yml-check
lint-prometheus: promtool-check-rules
lint-alertmanager: amtool-check-config

# Markdown
include build-support/alpha-build/core/markdown/env.mk
include build-support/alpha-build/core/markdown/format.mk
include build-support/alpha-build/core/markdown/lint.mk

.PHONY: fmt-md lint-md
fmt-md: markdownlint-fmt prettier-md
lint-md: markdownlint prettier-md-check

# HTML/CSS/Web
include build-support/alpha-build/core/html/lint.mk
include build-support/alpha-build/core/html/format.mk
include build-support/alpha-build/core/css/lint.mk
include build-support/alpha-build/core/css/format.mk

.PHONY: fmt-html lint-html fmt-css lint-css
fmt-html: prettier-html
lint-html: prettier-html-check
fmt-css: prettier-css
lint-css: prettier-css-check
fmt-web: fmt-html fmt-css
lint-web: lint-html lint-css

# Cross-language BUILD goals
.PHONY: env-default-replicate env-default-upgrade fmt lint type-check test clean

env-default-replicate: env-py-default-replicate env-sh-default-replicate env-md-default-replicate env-prettier-default-replicate
env-default-upgrade: env-py-default-upgrade env-sh-default-upgrade env-md-default-upgrade env-prettier-default-upgrade

fmt: fmt-py fmt-nb fmt-yml fmt-md fmt-sh fmt-html fmt-web

fmt-check: fmt-check-py fmt-check-nb

lint: lint-py lint-sh lint-nb lint-yml lint-md lint-html lint-prometheus lint-alertmanager lint-web # lint-hs

type-check: mypy

test: test-py test-sh

clean: clean-py clean-hs

# DEPLOY tools
ansible-cfg:
	$(eval ansible-bin := /home/cristian/apps/miniconda3/envs/ansible/bin)
	$(eval inventory := deploy-support/management/ansible/hosts.ini)

restart-%:
	$(eval logdir := ./mylogs)
	$(eval servicename := $(subst restart-,,$@))
	. lib_sh_utils/src/background.sh; \
	run_command_in_background ./deploy-support/services/$(servicename)/restart.sh $(logdir)/logs/$(servicename)
	#$(call run_cmd_in_bg,./deploy-support/services/$(servicename)/restart.sh,$(logdir)/logs/$(servicename))

kill-%:
	$(eval servicename := $(subst kill-,,$@))
	./deploy-support/services/$(servicename)/kill.sh

upgrade-%:
	$(eval servicename := $(subst upgrade-,,$@))
	./deploy-support/services/$(servicename)/install.sh

restart_all: restart-airflow restart_monitoring
restart_monitoring: restart-prometheus restart-grafana restart-alertmanager restart-node_exporter
restart_monitoring2: ansible-cfg
	$(eval playbook := deploy-support/management/ansible/playbooks/restart_monitoring.yml)
	"$(ansible-bin)/ansible-playbook" -i "$(inventory)" "$(playbook)" $(shell if [ ! -z "$(tags)" ]; then echo "--tags $(tags)"; fi)

kill_all: kill-airflow kill_monitoring
kill_monitoring: kill-prometheus kill-grafana kill-alertmanager
kill_monitoring2: ansible-cfg
	$(eval playbook := deploy-support/management/ansible/playbooks/kill_monitoring.yml)
	"$(ansible-bin)/ansible-playbook" -i "$(inventory)" "$(playbook)" $(shell if [ ! -z "$(tags)" ]; then echo "--tags $(tags)"; fi)

# OTHER ----------------------------------------------------------------------------------------------------------------
.PHONY: pre-commit install-pre-commit-hook uninstall-pre-commit-hook

# Run as `make pre-commit since=--cached`
pre-commit: lint pre-commit-tool

install-pre-commit-hook:
	cp build-support/git-hooks/pre-commit .git/hooks/
	# python -m pre_commit install  # Uncomment if you are using pre-commit (the tool)

uninstall-pre-commit-hook:
	rm .git/hooks/pre-commit
	# python -m pre_commit uninstall  # Uncomment if you are using pre-commit (the tool)

rm-envs:
	rm -rf 3rdparty/md-env/node_modules/ 3rdparty/sh-env/node_modules/  3rdparty/prettier-env/node_modules/
