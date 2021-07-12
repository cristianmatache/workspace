test-py: pytest

pytest:
	$(eval on := $(onpy))
	$(eval marks := "")
	if $(call lang,$(on),".*\.py"); then \
  	python -m pytest -m $(marks) -c $(call solve_on,$(on)); fi
