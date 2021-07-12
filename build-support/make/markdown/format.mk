fmt-md: markdownlint-fmt

markdownlint-fmt:
	$(eval on := $(onmd))
	$(eval mdlint := $(MARKDOWNLINT_BIN))
	if $(call lang,$(on),".*\.md"); then \
	$(mdlint) --config $(MARKDOWNLINT_CONFIG) --fix $(call solve_on,$(on)); fi;
