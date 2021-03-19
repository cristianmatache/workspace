MAKEFLAGS += -j4

# Aliases
iqor=app_iqor/

# All projects
onpy=algo/ iqor app_paper_plane/ lib_py_utils/ lib_bzl_utils/
onhs=tutorials_hs/scheme_interpreter
onsh=build-support/

# Common args
line_len=120

# Config files
MYPY_CONFIG=build-support/mypy.ini
PYLINT_CONFIG=build-support/.pylintrc
FLAKE8_CONFIG=build-support/.flake8
BANDIT_CONFIG=build-support/.bandit.yml
export


SOURCES_ROOTS=app_iqor:app_paper_plane:lib_py_utils
ifneq ($(shell uname | egrep -i "mingw"),)
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)" | sed 's/:/;/g');$(PYTHONPATH)
else
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)"):$(PYTHONPATH)
endif


# If "on" was supplied as an alias -> solve the alias, otherwise pass in the raw on
# Args:
#	- on: named file/dir target(s) specifier
define solve_on
$(foreach dir, $1, $(or ${$(dir)},${dir},$1))
endef


# If "since" was supplied -> get all the changed files since $(since)
# Args:
# 	- since: e.g. HEAD, master, feature/my-branch
#   - extension: e.g. ".py"
define solve_since
$(shell git diff --name-only $1 | grep "$2" | tr '\n' ' ')
endef

# FORMAT ---------------------------------------------------------------------------------------------------------------
fmt-py: docformatter isort autoflake

fmt: fmt-py

docformatter:
	$(eval on := $(onpy))
ifeq ($(since),)
	docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on))
else
	docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort:
	$(eval on := $(onpy))
ifeq ($(since),)
	isort -m 2 -l $(line_len) $(call solve_on,$(on))
else
	isort -m 2 -l $(line_len) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"isort -m 2 -l $(line_len)",$(call solve_on,$(on)))

autoflake:
	$(eval on := $(onpy))
ifeq ($(since),)
	autoflake --in-place --remove-all-unused-imports -r $(call solve_on,$(on))
else
	autoflake --in-place --remove-all-unused-imports -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"autoflake --in-place --remove-all-unused-imports -r")

# TYPE-CHECK -----------------------------------------------------------------------------------------------------------
mypy:
	$(eval on := $(onpy))
ifeq ($(since),)
	mypy --config-file $(MYPY_CONFIG) $(call solve_on,$(on))
else
	mypy --config-file $(MYPY_CONFIG) $(call solve_since,$(since),".py")
endif
# $(call smart_command,"mypy --config-file $(MYPY_CONFIG)",$(call solve_on,$(on)))

# LINT -----------------------------------------------------------------------------------------------------------------
lint: lint-py lint-sh lint-hs

lint-py: flake8 autoflake-check docformatter-check isort-check bandit pylint

autoflake-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	autoflake --in-place --remove-all-unused-imports --check -r $(call solve_on,$(on))
#	$(call smart_command,"autoflake --in-place --remove-all-unused-imports --check -r",$(call solve_on,$(on)))
else
	autoflake --in-place --remove-all-unused-imports --check -r $(call solve_since,$(since),".py")
#	$(call smart_command,"autoflake --in-place --remove-all-unused-imports --check -r",$(call solve_since,$(since),".py"))
endif

docformatter-check: docformatter-diff docformatter-actual-check

docformatter-actual-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(call solve_on,$(on))
else
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r",$(call solve_on,$(on)))

docformatter-diff:
	$(eval on := $(onpy))
ifeq ($(since),)
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on))
else
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	isort --diff --color --check-only -m 2 -l $(line_len) $(call solve_on,$(on))
else
	isort --diff --color --check-only -m 2 -l $(line_len) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"isort --diff --color --check-only -m 2 -l $(line_len)")

flake8:
	$(eval on := $(onpy))
ifeq ($(since),)
	flake8 --config=$(FLAKE8_CONFIG) $(call solve_on,$(on))
else
	flake8 --config=$(FLAKE8_CONFIG) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"flake8 --config=build-support/.flake8")

bandit:
	$(eval on := $(onpy))
ifeq ($(since),)
	bandit --configfile $(BANDIT_CONFIG) -r $(call solve_on,$(on))
else
	bandit --configfile $(BANDIT_CONFIG) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"bandit --configfile $(BANDIT_CONFIG) -r",$(call solve_on,$(on)))

pylint:
	$(eval on := $(onpy))
ifeq ($(since),)
	pylint --rcfile=$(PYLINT_CONFIG) $(call solve_on,$(on))
else
	pylint --rcfile=$(PYLINT_CONFIG) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"pylint --rcfile=$(PYLINT_CONFIG),$(call solve_on,$(on))")

hlint:
	$(eval on := $(onhs))
ifeq ($(since),)
	$(call smart_command,"hlint",$(call solve_on,$(on)))
#	hlint $(call solve_on,$(on))
else
	$(call smart_command,"hlint",$(call solve_since,$(since),".hs"))
#	hlint $(call solve_since,$(since),".hs")
endif

shellcheck:
	$(eval on := $(onsh))
ifeq ($(since),)
	find $(call solve_on,$(on)) -type f -iname "*.sh" -exec shellcheck --format=gcc -e SC1017 {} \;
else
	find $(call solve_since,$(since),".sh") -type f -iname "*.sh" -exec shellcheck --format=gcc -e SC1017 {} \;
endif

lint-hs: hlint

lint-sh: shellcheck

# CLEAN ----------------------------------------------------------------------------------------------------------------
clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

clean-build-utils:
	rm -rf lib_py_utils/build/
	rm -rf lib_py_utils/dist/
	rm -rf lib_py_utils/*.egg-info

clean-hs:
	find . -name *.hi | xargs rm -f && find . -name *.o | xargs rm -f;


# INSTALLATION ---------------------------------------------------------------------------------------------------------
pip-install:
	pip install --upgrade pip && \
	pip install -c 3rdparty/constraints.txt -r 3rdparty/requirements.txt -r 3rdparty/dev-requirements.txt

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
