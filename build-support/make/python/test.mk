test-py: pytest

pytest:
	$(eval on := $(onpy))
	$(eval marks := "")
ifeq ($(since),)
	if $(call lang,$(on),".*\.py"); then \
  	python -m pytest -m $(marks) -c $(call solve_on,$(on)); fi
else
	python -m pytest -m $(marks) -c $(call solve_since,$(since),".py");
endif
