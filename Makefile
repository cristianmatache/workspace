MAKEFLAGS += -j4

export on=algo/ app_iqor/ app_paper_plane/ lib_py_utils/ lib_bzl_utils/
export line_len=120

# FORMAT ---------------------------------------------------------------------------------------------------------------
docformatter:
	docformatter -r $(on) --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len)

isort:
	isort $(on) -m 2 -l $(line_len)

fmt: docformatter isort

# TYPE-CHECK -----------------------------------------------------------------------------------------------------------
mypy:
	mypy algo/ app_iqor/ app_paper_plane/ lib_py_utils/ lib_bzl_utils/ --config-file .build-support/mypy.ini

# LINT -----------------------------------------------------------------------------------------------------------------
lint-py: flake8 docformatter-check isort-check bandit

docformatter-check:
	docformatter -r $(on) --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) && \
	docformatter -r $(on) --check --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len)

isort-check:
	isort --diff --color $(on) -m 2 -l $(line_len) && \
	isort --check-only $(on) -m 2 -l $(line_len)

flake8:
	flake8 $(on) --config=.build-support/.flake8

bandit:
	bandit -r $(on) --configfile .build-support/.bandit.yml

pylint:
	pylint $(on) --rcfile=.build-support/.pylintrc

lint-hs:
	hlint tutorials_hs/scheme_interpreter

# OTHERS ---------------------------------------------------------------------------------------------------------------
clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

pre-commit: mypy lint-py

clean-build-utils:
	rm -rf lib_py_utils/build/
	rm -rf lib_py_utils/dist/
	rm -rf lib_py_utils/*.egg-info
