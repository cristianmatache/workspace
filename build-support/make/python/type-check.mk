type-check: mypy

mypy:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m mypy --config-file $(MYPY_CONFIG) $(call solve_on,$(on)); fi
