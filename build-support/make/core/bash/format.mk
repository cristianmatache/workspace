shfmt:
	$(eval on := $(onsh))
	if $(call lang,$(on),".*\.sh"); then \
	shfmt -w $(call solve_on,$(on)); fi
