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

# FORMAT ---------------------------------------------------------------------------------------------------------------
docformatter:
	$(eval on := $(onpy))
	docformatter -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len)

isort:
	$(eval on := $(onpy))
	isort $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on))) -m 2 -l $(line_len)

autoflake:
	$(eval on := $(onpy))
	autoflake -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on))) --in-place --remove-all-unused-imports

fmt: docformatter isort autoflake

# TYPE-CHECK -----------------------------------------------------------------------------------------------------------
mypy:
	$(eval on := $(onpy))
	mypy $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --config-file build-support/mypy.ini

# LINT -----------------------------------------------------------------------------------------------------------------
lint-py: flake8 docformatter-check isort-check bandit pylint

docformatter-check:
	$(eval on := $(onpy))
	docformatter -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) && \
	docformatter -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --check --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len)

isort-check:
	$(eval on := $(onpy))
	isort --diff --color $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  -m 2 -l $(line_len) && \
	isort --check-only $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  -m 2 -l $(line_len)

flake8:
	$(eval on := $(onpy))
	flake8 $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --config=build-support/.flake8

bandit:
	$(eval on := $(onpy))
	bandit -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --configfile build-support/.bandit.yml

pylint:
	$(eval on := $(onpy))
	pylint $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --rcfile=build-support/.pylintrc

hlint:
	$(eval on := $(onhs))
	hlint $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))

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
	pip install -c 3rdparty/constraints.txt -r 3rdparty/requirements.txt -r 3rdparty/dev-requirements.txt --ignore-installed PyYAML

# OTHER ----------------------------------------------------------------------------------------------------------------
pre-commit: mypy lint-py lint-sh lint-hs
