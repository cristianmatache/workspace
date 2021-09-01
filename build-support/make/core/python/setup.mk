ifneq ($(shell uname | egrep -i "mingw|NT-"),)
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(PY_SOURCES_ROOTS)" | sed 's/:/;/g');$(PYTHONPATH)
else
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(PY_SOURCES_ROOTS)"):$(PYTHONPATH)
endif

env-py-default-replicate:  # With constraints for full reproducibility
	python -m pip install --upgrade pip
	python -m pip install \
	-c $(DEFAULT_PYTHON_ENV)/constraints.txt \
	-r $(DEFAULT_PYTHON_ENV)/requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/dev-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/mypy-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/nb-requirements.txt

env-py-default-upgrade:  # Without constraints to allow pip to resolve deps again
	python -m pip install --upgrade pip setuptools
	python -m pip install \
	-r $(DEFAULT_PYTHON_ENV)/requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/dev-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/mypy-requirements.txt \
	-r $(DEFAULT_PYTHON_ENV)/nb-requirements.txt
	pip list --format=freeze > $(DEFAULT_PYTHON_ENV)/constraints.txt
	pip check
