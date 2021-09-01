hlint:
	$(eval on := $(onhs))
	if $(call lang,$(on),".*\.hs"); then  \
	hlint $(call solve_on,$(on))
