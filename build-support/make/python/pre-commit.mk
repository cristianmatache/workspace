pre-commit-tool:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	find $(call solve_on,$(on)) -type f -regex ".*\.pyi?" -print0 | xargs -0 pre-commit run --files; fi
else
	find $(call solve_since,$(since),".py") -type f -regex ".*\.pyi?" -print0 | xargs -0 pre-commit run --files
endif
