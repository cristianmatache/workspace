fmt-nb: nbstripout jblack

jblack:
	$(eval on := $(onnb))
	if $(call lang,$(on),".*\.ipynb"); then \
  	python -m jupyterblack --line-length $(line_len) $(call solve_on,$(on)); fi

nbstripout:
	$(eval on := $(onnb))
	if $(call lang,$(on),".*\.ipynb"); then \
  	find $(call solve_on,$(on)) -type f -name "*.ipynb" -print | xargs python -m nbstripout --strip-empty-cells; fi
