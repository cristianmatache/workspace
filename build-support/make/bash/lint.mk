lint-sh: shellcheck

# find .. --exec always has exit code 0 -> use find | xargs
shellcheck:
	$(eval on := $(onsh))
ifeq ($(since),)
	if $(call lang,$(on),".*\.sh"); then \
	find $(call solve_on,$(on)) -type f -iname "*.sh" | xargs --no-run-if-empty shellcheck --format=gcc -e SC1017; fi
else
	find $(call solve_since,$(since),".sh") -type f -iname "*.sh" | xargs --no-run-if-empty shellcheck --format=gcc -e SC1017;
endif
#	find $(call solve_on,$(on)) -type f -iname "*.sh" -exec sh -c 'for f; do shellcheck "$$f" --format=gcc -e SC1017 || exit 1; done' sh "{}" \+; fi
