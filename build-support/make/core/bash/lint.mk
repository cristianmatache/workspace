# find .. --exec always has exit code 0 -> use find | xargs
shellcheck:
	$(eval on := $(onsh))
	if $(call lang,$(on),".*\.sh"); then \
	find $(call solve_on,$(on)) -type f -iname "*.sh" | xargs shellcheck -x --format=gcc -e SC1017; fi

shfmt-check:
	$(eval on := $(onsh))
	if $(call lang,$(on),".*\.sh"); then \
	shfmt -d $(call solve_on,$(on)); fi
