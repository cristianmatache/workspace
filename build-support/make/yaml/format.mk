fmt-yml: dos2unix-yml

dos2unix-yml:
	$(eval on := $(onyml))
	if $(call lang,$(on),".*\.ya?ml"); then \
	find $(call solve_on,$(on)) -type f -regex ".*\.ya?ml" | xargs --no-run-if-empty dos2unix; fi;
