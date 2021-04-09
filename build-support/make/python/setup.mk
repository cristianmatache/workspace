SOURCES_ROOTS=app_iqor:app_paper_plane:lib_py_utils
ifneq ($(shell uname | egrep -i "mingw|NT-"),)
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)" | sed 's/:/;/g');$(PYTHONPATH)
else
	export PYTHONPATH := $(shell sed 's/\ //g' <<< "$(SOURCES_ROOTS)"):$(PYTHONPATH)
endif

env-py: env-py-replicate

env-py-replicate:
	pip install --upgrade pip
	pip install -c 3rdparty/py-env/constraints.txt -r 3rdparty/py-env/requirements.txt -r 3rdparty/py-env/dev-requirements.txt

env-py-create:
	pip install --upgrade pip
	pip install -r 3rdparty/py-env/requirements.txt -r 3rdparty/py-env/dev-requirements.txt

