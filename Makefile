clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

mypy:
	mypy algo/ app_iqor/ app_paper_plane/ lib_py_utils/ lib_bzl_utils/ --config-file .build-support/mypy.ini

flake8:
	flake8 . --config=.build-support/.flake8

bandit:
	bandit -r . --configfile .build-support/.bandit.yml

pylint:
	pylint algo/ app_iqor/ app_paper_plane/ lib_py_utils/py_utils/ lib_bzl_utils/ --rcfile=.build-support/.pylintrc

lintpy: mypy flake8 bandit pylint

linths:
	hlint tutorials_hs/scheme_interpreter

pre-commit: mypy flake8

clean-build-utils:
	rm -rf lib_py_utils/build/
	rm -rf lib_py_utils/dist/
	rm -rf lib_py_utils/*.egg-info
