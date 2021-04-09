fmt-py: docformatter isort autoflake

docformatter:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on)); fi
else
	docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	isort --settings-path $(ISORT_CONFIG) $(call solve_on,$(on)); fi
else
	isort --settings-path $(ISORT_CONFIG) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"isort -m 2 -l $(line_len)",$(call solve_on,$(on)))

autoflake:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	autoflake --in-place --remove-all-unused-imports -r $(call solve_on,$(on)); fi
else
	autoflake --in-place --remove-all-unused-imports -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"autoflake --in-place --remove-all-unused-imports -r")
