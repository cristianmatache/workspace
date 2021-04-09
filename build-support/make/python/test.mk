test-py: pytest

pytest:
	$(eval on := $(onpy))
	$(eval marks := "")
ifeq ($(since),)
	if $(call lang,$(on),".*\.ipynb"); then \
  	pytest -m $(marks) -c $(call solve_on,$(on)); fi
else
	pytest -m $(marks) -c $(call solve_since,$(since),".ipynb");
endif
