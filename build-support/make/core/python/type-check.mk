mypy:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	which pip; \
	which python; \
	python -m mypy --config-file $(MYPY_CONFIG) $(call solve_on,$(on)); fi
