fmt-yml: dos2unix-yml

dos2unix-yml:
	$(eval on := $(onyml))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ya?ml"); then \
	find $(call solve_on,$(on)) -type f -regex ".*\.ya?ml" | xargs --no-run-if-empty dos2unix; fi;
else
	find $(call solve_since,$(since),".yml") -type f -regex ".*\.y[a]ml" | xargs --no-run-if-empty dos2unix
endif
