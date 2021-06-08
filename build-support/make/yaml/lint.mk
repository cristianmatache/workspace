lint-yml: yamllint

# find .. --exec always has exit code 0 -> use find | xargs
yamllint:
	$(eval on := $(onyml))
ifeq ($(since),)
	if $(call lang,$(on),".*\.y[a]ml"); then \
	yamllint -c $(YAMLLINT_CONFIG) $(call solve_on,$(on)); fi
else
	yamllint -c $(YAMLLINT_CONFIG) $(call solve_since,$(since),".yml");
endif
