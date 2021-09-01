bats:
	$(eval on := $(onsh))
	$(eval batsexec := $(BATS_BIN))
	if $(call lang,$(on),".*\.bats"); then \
  	./$(batsexec) -r $(call solve_on,$(on)); fi
