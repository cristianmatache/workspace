type-check: mypy

mypy:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m mypy --config-file $(MYPY_CONFIG) $(call solve_on,$(on)); fi
else
	python -m mypy --config-file $(MYPY_CONFIG) $(call solve_since,$(since),".py")
endif
# $(call smart_command,"mypy --config-file $(MYPY_CONFIG)",$(call solve_on,$(on)))
