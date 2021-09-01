pre-commit-tool:
	$(eval on := $(onpy) $(onsh) $(onyml))
	if $(call lang,$(on),".*\.pyi?"); then  \
	find $(call solve_on,$(on)) -type f -regex ".*\.pyi?" -print0 | xargs -0 pre-commit run --files; fi
