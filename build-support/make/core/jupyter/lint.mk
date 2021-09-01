jblack-check:
	$(eval on := $(onnb))
	if $(call lang,$(on),".*\.ipynb"); then \
  	python -m jupyterblack --check --line-length $(line_len) $(call solve_on,$(on)); fi

flake8-nb:
	$(eval on := $(onnb))
	if $(call lang,$(on),".*\.ipynb"); then \
  	find $(call solve_on,$(on)) -type f -iname "*.ipynb" | xargs python -m flake8_nb --config $(FLAKE8_NB_CONFIG); fi
