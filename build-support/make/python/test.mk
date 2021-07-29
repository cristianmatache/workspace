test-py: pytest

pytest:
	$(eval on := $(onpy))
	$(eval marks := "")
	if $(call lang,$(on),".*\.py"); then \
  	python -m coverage run -m pytest -m $(marks) -c $(PYTEST_CONFIG) $(call solve_on,$(on)) && python -m coverage html; fi
