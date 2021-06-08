lint-yml: yamllint

yamllint:
	$(eval on := $(onyml))
ifeq ($(since),)
	if $(call lang,$(on),".*\.y[a]ml"); then \
	python -m yamllint -c $(YAMLLINT_CONFIG) $(call solve_on,$(on)); fi
else
	find $(call solve_since,$(since),".yml") -type f -regex ".*\.ya?ml" | xargs --no-run-if-empty python -m yamllint -c $(YAMLLINT_CONFIG);
endif
