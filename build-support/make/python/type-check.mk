mypy:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	mypy --config-file $(MYPY_CONFIG) $(call solve_on,$(on)); fi
else
	mypy --config-file $(MYPY_CONFIG) $(call solve_since,$(since),".py")
endif
# $(call smart_command,"mypy --config-file $(MYPY_CONFIG)",$(call solve_on,$(on)))
