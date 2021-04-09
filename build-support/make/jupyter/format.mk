fmt-nb: jblack

jblack:
	$(eval on := $(onnb))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	jblack --line-length $(line_len) $(call solve_on,$(on)); fi
else
	jblack --line-length $(line_len) $(call solve_since,$(since),".ipynb");
endif
