MAKEFLAGS += -j4

# Aliases
iqor=app_iqor/

# All projects
onpy=algo/ iqor app_paper_plane/ lib_py_utils/ lib_bzl_utils/
onhs=tutorials_hs/scheme_interpreter
onsh=build-support/

# Common args
line_len=120
export

export PYTHONPATH := app_iqor:app_paper_plane:lib_py_utils:$(PYTHONPATH)


# FORMAT ---------------------------------------------------------------------------------------------------------------
fmt-py: docformatter isort autoflake

fmt: fmt-py

docformatter:
	$(eval on := $(onpy))
	docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort:
	$(eval on := $(onpy))
	isort -m 2 -l $(line_len) $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"isort -m 2 -l $(line_len)")

autoflake:
	$(eval on := $(onpy))
	autoflake --in-place --remove-all-unused-imports -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"autoflake --in-place --remove-all-unused-imports -r")

# TYPE-CHECK -----------------------------------------------------------------------------------------------------------
mypy:
	$(eval on := $(onpy))
	mypy --config-file build-support/mypy.ini $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
# $(call smart_command,"mypy --config-file build-support/mypy.ini")

# LINT -----------------------------------------------------------------------------------------------------------------
lint: lint-py lint-sh lint-hs

lint-py: flake8 autoflake-check docformatter-check isort-check bandit pylint

autoflake-check:
	$(eval on := $(onpy))
	autoflake --in-place --remove-all-unused-imports --check -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"autoflake --in-place --remove-all-unused-imports --check -r")


docformatter-check: docformatter-diff docformatter-actual-check

docformatter-actual-check:
	$(eval on := $(onpy))
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r")

docformatter-diff:
	$(eval on := $(onpy))
	docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort-check:
	$(eval on := $(onpy))
	isort --diff --color --check-only -m 2 -l $(line_len) $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"isort --diff --color --check-only -m 2 -l $(line_len)")

flake8:
	$(eval on := $(onpy))
	flake8 --config=build-support/.flake8 $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"flake8 --config=build-support/.flake8")

bandit:
	$(eval on := $(onpy))
	#unset PYTHONPATH && python -m bandit --configfile build-support/.bandit.yml -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
	bandit --configfile build-support/.bandit.yml -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"unset PYTHONPATH && bandit --configfile build-support/.bandit.yml -r")

pylint:
	$(eval on := $(onpy))
	pylint --rcfile=build-support/.pylintrc $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"pylint --rcfile=build-support/.pylintrc")

hlint:
	$(eval on := $(onhs))
	hlint $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))
#$(call smart_command,"hlint")

shellcheck:
	$(eval on := $(onsh))
	find $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on))) -type f -iname "*.sh" -exec shellcheck --format=gcc -e SC1017 {} \;

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
# 1. expand aliases passed in "on" if any
# 2. work out which target directories/files belong to subsystems (inner makefiles) such that we forward the make rule
# 3. smart_command is passed the actual command apart from the file/dir targets (which will be injected at the end)
#		- for each subsystem work out which files actually belong to it
# 		- if a whole subsystem is passed but no files/dirs inside it -> make inner makefile without "on"s to use the
#		  defaults in that makefile
# 	    - if files/subdirs of a subsystem are passed in forward them as "on"-s and remove the base path
# 		  hence there will be no problems with cd
define smart_command
	$(eval resolved_on := $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on))))
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
