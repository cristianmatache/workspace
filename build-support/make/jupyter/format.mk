fmt-nb: nbstripout jblack

jblack:
	$(eval on := $(onnb))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	python -m jupyterblack --line-length $(line_len) $(call solve_on,$(on)); fi
else
	python -m jupyterblack --line-length $(line_len) $(call solve_since,$(since),".ipynb");
endif

nbstripout:
	$(eval on := $(onnb))
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	find $(call solve_on,$(on)) -type f -name "*.ipynb" -print | xargs python -m nbstripout --strip-empty-cells; fi
else
	find $(call solve_since,$(since),".ipynb") -type f -name "*.ipynb" -print | xargs python -m nbstripout --strip-empty-cells;
endif
