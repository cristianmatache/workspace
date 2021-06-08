test-sh: bats

bats:
	$(eval on := $(onsh))
	$(eval batsexec := $(BATS_BIN))
ifeq ($(since),)
	if $(call lang,$(on),".*\.bats"); then \
  	./$(batsexec) -r $(call solve_on,$(on)); fi
else
	./$(batsexec) -r $(call solve_since,$(since),".bats");
endif
