mypy:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	pip freeze
	pip show types-requests
	python -m mypy --config-file $(MYPY_CONFIG) $(call solve_on,$(on)); fi
