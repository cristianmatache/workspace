lint-nb: jblack-check flake8-nb

jblack-check:
	$(eval on := $(onnb))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	python -m jupyterblack --check --line-length $(line_len) $(call solve_on,$(on)); fi
else
	python -m jupyterblack --check --line-length $(line_len) $(call solve_since,$(since),".ipynb");
endif

flake8-nb:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	flake8_nb --config $(FLAKE8_NB_CONFIG) $(call solve_on,$(on)); fi
else
	find $(call solve_since,$(since),".ipynb") -type f -name "*.ipynb" | xargs --no-run-if-empty flake8_nb --config $(FLAKE8_NB_CONFIG);
endif
