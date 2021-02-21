MAKEFLAGS += -j4

iqor=app_iqor/
on=algo/ iqor app_paper_plane/ lib_py_utils/ lib_bzl_utils/
line_len=120
export

# FORMAT ---------------------------------------------------------------------------------------------------------------
docformatter:
	docformatter -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len)

isort:
	isort $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on))) -m 2 -l $(line_len)

autoflake:
	autoflake -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on))) --in-place --remove-all-unused-imports

fmt: docformatter isort autoflake

# TYPE-CHECK -----------------------------------------------------------------------------------------------------------
mypy:
	mypy $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --config-file build-support/mypy.ini

# LINT -----------------------------------------------------------------------------------------------------------------
lint-py: flake8 docformatter-check isort-check bandit pylint

docformatter-check:
	docformatter -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) && \
	docformatter -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --check --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len)

isort-check:
	isort --diff --color $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  -m 2 -l $(line_len) && \
	isort --check-only $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  -m 2 -l $(line_len)

flake8:
	flake8 $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --config=build-support/.flake8

bandit:
	bandit -r $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --configfile build-support/.bandit.yml

pylint:
	pylint $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))  --rcfile=build-support/.pylintrc

hlint:
	hlint tutorials_hs/scheme_interpreter

lint-hs: hlint

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
pre-commit: mypy lint-py lint-hs
