lint-yml: yamllint

yamllint:
	$(eval on := $(onyml))
ifeq ($(since),)
	if $(call lang,$(on),".*\.y[a]ml"); then \
	python -m yamllint --strict -c $(YAMLLINT_CONFIG) $(call solve_on,$(on)); fi
else
	if $(call lang,$(call solve_since,$(since),".yml"),".*\.ya?ml"); then \
	python -m yamllint --strict -c $(YAMLLINT_CONFIG) $(call solve_since,$(since),".yml"); fi
endif
