lint-nb: flake8-nb fmt-check-nb

fmt-check-nb: jblack-check

jblack-check:
	$(eval on := $(onnb))
	if $(call lang,$(on),".*\.ipynb"); then \
  	python -m jupyterblack --check --line-length $(line_len) $(call solve_on,$(on)); fi

flake8-nb:
	$(eval on := $(onnb))
	if $(call lang,$(on),".*\.ipynb"); then \
  	flake8_nb --config $(FLAKE8_NB_CONFIG) $(call solve_on,$(on)); fi
