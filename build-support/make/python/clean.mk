clean-py: clean-pyc clean-build-utils

clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

clean-build-utils:
	rm -rf lib_py_utils/build/
	rm -rf lib_py_utils/dist/
	rm -rf lib_py_utils/*.egg-info
