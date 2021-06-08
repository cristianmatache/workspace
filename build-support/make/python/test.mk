test-py: pytest

pytest:
	$(eval on := $(onpy))
	$(eval marks := "")
ifeq ($(since),)
	if $(call lang,$(on),".*\.py"); then \
  	pytest -m $(marks) -c $(call solve_on,$(on)); fi
else
	pytest -m $(marks) -c $(call solve_since,$(since),".py");
endif
