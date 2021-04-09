lint-hs: hlint

hlint:
	$(eval on := $(onhs))
ifeq ($(since),)
	if $(call lang,$(on),".*\.hs"); then  \
#	$(call smart_command,"hlint",$(call solve_on,$(on))); fi
	hlint $(call solve_on,$(on))
else
#	$(call smart_command,"hlint",$(call solve_since,$(since),".hs"))
	hlint $(call solve_since,$(since),".hs")
endif
