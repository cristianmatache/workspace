yamllint:
	$(eval on := $(onyml))
	if $(call lang,$(on),".*\.ya?ml"); then \
	python -m yamllint --strict -c $(YAMLLINT_CONFIG) $(call solve_on,$(on)); fi
