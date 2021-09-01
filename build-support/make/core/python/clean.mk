clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

clean-pytest:
	find . -name .pytest_cache -type d -exec rm -rf {} +
	find . -name .hypothesis -type d -exec rm -rf {} +

clean-mypy:
	find -rf .mypy_cache
