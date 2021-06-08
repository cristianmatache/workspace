SOURCES_ROOTS=app_iqor:app_paper_plane:lib_py_utils
ifneq ($(shell uname | egrep -i "mingw|NT-"),)
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)" | sed 's/:/;/g');$(PYTHONPATH)
else
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)"):$(PYTHONPATH)
endif

WS_ENV='3rdparty/py-env-ws'

env-py: env-py-ws-replicate

env-py-ws-replicate:
	python -m pip install --upgrade pip
	python -m pip install -c $(WS_ENV)/constraints.txt -r $(WS_ENV)/requirements.txt -r $(WS_ENV)/dev-requirements.txt -r $(WS_ENV)/nb-requirements.txt

env-py-ws-create:
	python -m pip install --upgrade pip setuptools
	python -m pip install -r $(WS_ENV)/requirements.txt -r $(WS_ENV)/dev-requirements.txt -r $(WS_ENV)/nb-requirements.txt
	pip list --format=freeze > $(WS_ENV)/constraints.txt
	pip check

env-py-airflow-replicate:
	$(eval AIRFLOW_VERSION := 2.1.0)
	$(eval PYTHON_VERSION := $(shell python --version | cut -d " " -f 2 | cut -d "." -f 1-2))
	python -m pip install "apache-airflow[async,postgres,statsd]==$(AIRFLOW_VERSION)" airflow-exporter --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-$(AIRFLOW_VERSION)/constraints-$(PYTHON_VERSION).txt"
