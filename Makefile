SHELL := /bin/bash
MAKEFLAGS += -j4

# Aliases
iqor=app_iqor/ 

# All projects
onpy=algo/ iqor app_paper_plane/ lib_py_utils/ lib_bzl_utils/
onsh=build-support/ deploy-support/ lib_sh_utils/
onhs=tutorials_hs/scheme_interpreter
onnb=notebooks/
onyml=.ci-azure/ build-support/ deploy-support/ .pre-commit-config.yaml
onmd=*.md app_* lib_* resources/

ifneq ($(since),)
onpy=$(call files_that_exist,$(shell git diff --name-only $(since) | grep -E "*\.pyi?" | grep -v ".pylintrc"))
onsh=$(call files_that_exist,$(shell git diff --name-only $(since) | grep -E "*\.sh"))
onhs=$(call files_that_exist,$(shell git diff --name-only $(since) | grep -E "*\.hs"))
onnb=$(call files_that_exist,$(shell git diff --name-only $(since) | grep -E "*\.ipynb"))
onyml=$(call files_that_exist,$(shell git diff --name-only $(since) | grep -E "*\.ya?ml"))
onmd=$(call files_that_exist,$(shell git diff --name-only $(since) | grep -E "*\.md"))
endif

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
