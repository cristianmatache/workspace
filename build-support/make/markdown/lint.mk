lint-md: markdownlint

markdownlint:
	$(eval on := $(onmd))
	$(eval mdlint := $(MARKDOWNLINT_BIN))
ifeq ($(since),)
	if $(call lang,$(on),".*\.md"); then \
	./$(mdlint) --config $(MARKDOWNLINT_CONFIG) $(call solve_on,$(on)); fi;
else
	./$(mdlint) --config $(MARKDOWNLINT_CONFIG) $(call solve_since,$(since),".md")
endif