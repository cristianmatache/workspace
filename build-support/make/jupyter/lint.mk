lint-nb: jblack-check flake8-nb

jblack-check:
	$(eval on := $(onnb))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	jblack --check --line-length $(line_len) $(call solve_on,$(on)); fi
else
	jblack --check --line-length $(line_len) $(call solve_since,$(since),".ipynb");
endif

flake8-nb:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	flake8_nb --config $(FLAKE8_NB_CONFIG) $(call solve_on,$(on)); fi
else
	flake8_nb --config $(FLAKE8_NB_CONFIG) $(call solve_since,$(since),".ipynb");
endif
