docformatter:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m docformatter --in-place --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on)); fi

isort:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m isort --settings-path $(ISORT_CONFIG) $(call solve_on,$(on)); fi
#$(call smart_command,"isort -m 2 -l $(line_len)",$(call solve_on,$(on)))

autoflake:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m autoflake --in-place --remove-all-unused-imports -r $(call solve_on,$(on)); fi

black:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m black -S --config $(BLACK_CONFIG) $(call solve_on,$(on)); fi

flynt:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m flynt $(call solve_on,$(on)); fi
