MAKEFLAGS += -j4

# Aliases
iqor=app_iqor/ 

# All projects
onpy=algo/ iqor app_paper_plane/ lib_py_utils/ lib_bzl_utils/
onhs=tutorials_hs/scheme_interpreter
onsh=build-support/
onnb=.

# Common args
line_len=120

# Config files
MYPY_CONFIG=build-support/python/tools-config/mypy.ini
PYLINT_CONFIG=build-support/python/tools-config/.pylintrc
FLAKE8_CONFIG=build-support/python/tools-config/.flake8
ISORT_CONFIG=build-support/python/tools-config/pyproject.toml
BANDIT_CONFIG=build-support/python/tools-config/.bandit.yml
PYTEST_CONFIG=build-support/python/tools-config/pyproject.toml
FLAKE8_NB_CONFIG=build-support/jupyter/tools-config/.flake8_nb
export


SOURCES_ROOTS=app_iqor:app_paper_plane:lib_py_utils
ifneq ($(shell uname | egrep -i "mingw|NT-"),)
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)" | sed 's/:/;/g');$(PYTHONPATH)
else
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)"):$(PYTHONPATH)
endif

# If "on" was supplied as an alias -> solve the alias, otherwise pass in the raw on
# Args:
#	- on: named file/dir target(s) specifier
solve_on = $(foreach target,$(foreach dir, $1, $(or ${$(dir)},${dir},$1)),$(call sanitize,${target}))

# Sanitize double/single/no quotes
ifneq ($(shell uname | egrep -i "msys"),)  # is cmd
sanitize = $(foreach target,$(shell echo $1 | tr '\\\\\\\\' '/' | tr -d "'" | tr -d '"' ),"$(target)")
else  # is Unix or Git bash
sanitize = $1
endif

# Only run the command if the "on" specs are suitable for the expected language
# Args:
#   - on: "on" specifier
#   - $2: file extension regex e.g. ".*\.pyi?" or ".*\.sh"
lang = [[ ! -z `find $(call solve_on,$1) -type f -regex $2` ]]

# If "since" was supplied -> get all the changed files since $(since)
# Args:
# 	- since: e.g. HEAD, master, feature/my-branch
#   - extension: e.g. ".py"
solve_since = $(shell git diff --name-only $1 | grep -F "$2" | xargs -d'\n' find 2>/dev/null | tr '\n' ' ')


# FORMAT ---------------------------------------------------------------------------------------------------------------
fmt: fmt-py fmt-nb

fmt-py: docformatter isort autoflake

fmt-nb: jblack

docformatter:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on)); fi
else
	docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	isort --settings-path $(ISORT_CONFIG) $(call solve_on,$(on)); fi
else
	isort --settings-path $(ISORT_CONFIG) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"isort -m 2 -l $(line_len)",$(call solve_on,$(on)))

autoflake:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	autoflake --in-place --remove-all-unused-imports -r $(call solve_on,$(on)); fi
else
	autoflake --in-place --remove-all-unused-imports -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"autoflake --in-place --remove-all-unused-imports -r")

jblack:
	$(eval on := $(onnb))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	jblack --line-length $(line_len) $(call solve_on,$(on)); fi
else
	jblack --line-length $(line_len) $(call solve_since,$(since),".ipynb");
endif


# TYPE-CHECK -----------------------------------------------------------------------------------------------------------
mypy:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	mypy --config-file $(MYPY_CONFIG) $(call solve_on,$(on)); fi
else
	mypy --config-file $(MYPY_CONFIG) $(call solve_since,$(since),".py")
endif
# $(call smart_command,"mypy --config-file $(MYPY_CONFIG)",$(call solve_on,$(on)))


# LINT -----------------------------------------------------------------------------------------------------------------
lint: lint-py lint-sh lint-nb # lint-hs

lint-hs: hlint

lint-sh: shellcheck

lint-py: flake8 autoflake-check docformatter-check isort-check bandit pylint

lint-nb: jblack-check flake8-nb

autoflake-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	autoflake --in-place --remove-all-unused-imports --check -r $(call solve_on,$(on)); fi
#	$(call smart_command,"autoflake --in-place --remove-all-unused-imports --check -r",$(call solve_on,$(on)))
else
	autoflake --in-place --remove-all-unused-imports --check -r $(call solve_since,$(since),".py")
#	$(call smart_command,"autoflake --in-place --remove-all-unused-imports --check -r",$(call solve_since,$(since),".py"))
endif

docformatter-check: docformatter-diff docformatter-actual-check

docformatter-actual-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(call solve_on,$(on)); fi
else
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r",$(call solve_on,$(on)))

docformatter-diff:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on)); fi
else
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	isort --diff --color --check-only --settings-path $(ISORT_CONFIG) $(line_len) $(call solve_on,$(on)); fi
else
	isort --diff --color --check-only --settings-path $(ISORT_CONFIG) $(line_len) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"isort --diff --color --check-only -m 2 -l $(line_len)")

flake8:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	flake8 --config=$(FLAKE8_CONFIG) $(call solve_on,$(on)); fi
else
	flake8 --config=$(FLAKE8_CONFIG) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"flake8 --config=build-support/.flake8")

bandit:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	bandit --configfile $(BANDIT_CONFIG) -r $(call solve_on,$(on)); fi
else
	bandit --configfile $(BANDIT_CONFIG) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"bandit --configfile $(BANDIT_CONFIG) -r",$(call solve_on,$(on)))

pylint:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	pylint --rcfile=$(PYLINT_CONFIG) $(call solve_on,$(on)); fi
else
	pylint --rcfile=$(PYLINT_CONFIG) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"pylint --rcfile=$(PYLINT_CONFIG),$(call solve_on,$(on))")

hlint:
	$(eval on := $(onhs))
ifeq ($(since),)
	if $(call lang,$(on),".*\.hs"); then  \
	$(call smart_command,"hlint",$(call solve_on,$(on))); fi
#	hlint $(call solve_on,$(on))
else
	$(call smart_command,"hlint",$(call solve_since,$(since),".hs"))
#	hlint $(call solve_since,$(since),".hs")
endif

# find .. --exec always has exit code 0 -> use find | xargs
shellcheck:
	$(eval on := $(onsh))
ifeq ($(since),)
	if $(call lang,$(on),".*\.sh"); then \
	find $(call solve_on,$(on)) -type f -iname "*.sh" | xargs shellcheck --format=gcc -e SC1017; fi
else
	find $(call solve_since,$(since),".sh") -type f -iname "*.sh" | xargs shellcheck --format=gcc -e SC1017;
endif
#	find $(call solve_on,$(on)) -type f -iname "*.sh" -exec sh -c 'for f; do shellcheck "$$f" --format=gcc -e SC1017 || exit 1; done' sh "{}" \+; fi

jblack-check:
	$(eval on := $(onnb))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	jblack --check --line-length $(line_len) $(call solve_on,$(on)); fi
else
	jblack --check --line-length $(line_len) $(call solve_since,$(since),".ipynb");
endif

flake8-nb:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	flake8_nb --config $(FLAKE8_NB_CONFIG) $(call solve_on,$(on)); fi
else
	flake8_nb --config $(FLAKE8_NB_CONFIG) $(call solve_since,$(since),".ipynb");
endif


# TEST -----------------------------------------------------------------------------------------------------------------
test: test-py

test-py: pytest

pytest:
	$(eval on := $(onpy))
	$(eval marks := "")
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	pytest -m $(marks) -c $(call solve_on,$(on)); fi
else
	pytest -m $(marks) -c $(call solve_since,$(since),".ipynb");
endif


# PACKAGE --------------------------------------------------------------------------------------------------------------
package-py: shiv

reqs-py:
	$(eval exclude := "dataclasses")
	$(eval env := py-env)
	reqs=$$(pipreqs --no-pin --print $(on) | grep -iv $(exclude) | sort); \
	pattern=$$(echo "$$reqs" | tr -d "\r" | tr "\n" "|" | awk '{print substr($$1, 1, length($$1)-1)}'); \
	first_p_reqs=$$(cat build-support/python/packaging/first-party-libs.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$2}'); \
	third_p_reqs=$$(cat 3rdparty/$(env)/requirements.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$1}'); \
	echo -e "$$first_p_reqs\n$$third_p_reqs";

reqs-py-libs:
	$(eval on := $(SOURCES_ROOTS))
	$(eval exclude := "dataclasses")
	$(eval env := py-env)
	$(eval delim := --------------------------------------------------)
	for lib in $$(echo $(on) | sed 's/:/\n/g'); do \
  		reqs=$$(pipreqs --no-pin --print $$lib | grep -iv $(exclude) | sort); \
  		pattern=$$(echo "$$reqs" | tr -d "\r" | tr "\n" "|" | awk '{print substr($$1, 1, length($$1)-1)}'); \
  		first_p_reqs=$$(cat build-support/python/packaging/first-party-libs.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$2}'); \
  		third_p_reqs=$$(cat 3rdparty/$(env)/requirements.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$1}'); \
  		echo "$$first_p_reqs" | sed 's/\ //g' > $$lib/generated-requirements.txt; \
  		echo "$$third_p_reqs" | sed 's/\ //g' >> $$lib/generated-requirements.txt; \
  		echo -e "$$lib\n$(delim)\n$$first_p_reqs\n$$third_p_reqs\n"; \
 	done

shiv:
	$(eval on := .)
	find $(on) -type f -name "shiv-package.sh" | sort | xargs bash


# DEV SETUP ------------------------------------------------------------------------------------------------------------
env: env-py

env-py:
	pip install --upgrade pip
	pip install -c 3rdparty/py-env/constraints.txt -r 3rdparty/py-env/requirements.txt -r 3rdparty/py-env/dev-requirements.txt

pip-install:
	pip install --upgrade pip
	pip install -r 3rdparty/py-env/requirements.txt -r 3rdparty/py-env/dev-requirements.txt


# CLEAN ----------------------------------------------------------------------------------------------------------------
clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

clean-build-utils:
	rm -rf lib_py_utils/build/
	rm -rf lib_py_utils/dist/
	rm -rf lib_py_utils/*.egg-info

clean-hs:
	find . -name *.hi | xargs rm -f && find . -name *.o | xargs rm -f;


# OTHER ----------------------------------------------------------------------------------------------------------------
pre-commit: mypy lint

# SUBSYSTEMS -----------------------------------------------------------------------------------------------------------
# Subsystems (i.e. inner projects with their own Makefiles)
subsystems=""

# smart_command explanation:
# What: if the targets belong to some subsystem, forward them to the inner makefile rule, else use the global one
# Why: if we need nested Makefile-s (normally it would be better to use the config files per sub-project)
# How:
# 1. expand aliases passed in "on/since" if any (i.e. $2)
# 2. work out which target directories/files belong to subsystems (inner makefiles) such that we forward the make rule
# 3. smart_command is passed the actual command ($1) apart from the file/dir targets ($2) (which will be appended)
#		- for each subsystem work out which files actually belong to it
# 		- if a whole subsystem is passed but no files/dirs inside it -> make inner makefile without "on"s to use the
#		  defaults in that makefile
# 	    - if files/subdirs of a subsystem are passed in forward them as "on"-s and remove the base path
# 		  hence there will be no problems with cd
define smart_command
	$(eval resolved_on := $2)
	$(eval to_make := $(foreach subsystem,$(subsystems),$(filter-out $(subsystem)%, $(resolved_on))))
	$(eval to_delegate := $(foreach subsystem,$(subsystems),$(filter $(subsystem)%, $(resolved_on))))
	command=$1; \
	if [[ "$(to_make)" != "" ]]; then \
		to_eval="$${command/\"/} $(to_make)"; \
		echo "!!!!!! EVALUATING: $$to_eval"; \
		eval "$$to_eval"; \
	fi \
	&& \
	if [[ "$(to_delegate)" != "" ]]; then \
		for subsystem in $(subsystems); do \
			dirs=""; \
			for dir in $(to_delegate); do \
				if [[ $$dir == $$subsystem* ]]; then dirs="$${dir/$$subsystem\//} $$dirs"; fi; \
			done; \
			if [[ "$$dirs" == "" ]]; then \
				to_eval='"$(MAKE)" $@ -C "$$subsystem"'; \
				echo "!!!!!! EVALUATING in $$subsystem: $$to_eval"; \
				eval "$$to_eval"; \
			else \
				echo "!!!!!! EVALUATING in $$subsystem: \"$(MAKE)\" $@ on=\"$$dirs\" -C \"$$subsystem\""; \
				"$(MAKE)" $@ on="$$dirs" -C "$$subsystem"; \
			fi; \
		done; \
	fi
endef
