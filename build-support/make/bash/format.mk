fmt-sh: shfmt

shfmt:
	$(eval on := $(onsh))
ifeq ($(since),)
	if $(call lang,$(on),".*\.sh"); then \
	shfmt -w $(call solve_on,$(on)); fi
else
	shfmt -w $(call solve_since,$(since),".sh")
endif
