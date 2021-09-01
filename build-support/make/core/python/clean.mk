clean-pyc:
	find . -name *.pyc | xargs rm -f && find . -name *.pyo | xargs rm -f;

clean-pytest:
	find . -name .pytest_cache -type d -exec rm -rf {} +
	find . -name .hypothesis -type d -exec rm -rf {} +

clean-mypy:
	rm -rf .mypy_cache

clean-egg-info:
	find . -name .hypothesis -type d -exec rm -rf {} +
