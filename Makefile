clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

mypy:
	mypy app_iqor/ app_paper_plane/ lib_py_utils/ --config-file .ini-files/mypy.ini

flake8:
	flake8 . --config=.ini-files/.flake8

bandit:
	bandit -r . --configfile .ini-files/.bandit.yml

pylint:
	pylint app_iqor/ app_paper_plane/ lib_py_utils/py_utils/  --rcfile=.ini-files/.pylintrc

lint: mypy flake8 bandit pylint

pre-commit: mypy flake8

clean-build-utils:
	rm -rf lib_py_utils/build/
	rm -rf lib_py_utils/dist/
	rm -rf lib_py_utils/*.egg-info
