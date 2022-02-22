# Inner Makefile example
SHELL := /bin/bash

include ../build-support/alpha-build/core/resolver.mk

dir=$(shell basename $(shell pwd))
this=py_utils/ test_utils/

alias1=py_utils/logging.py

# Forward to root Makefile
%:
	$(eval on := $(this))
	"$(MAKE)" -C .. $@ on="$(foreach item,$(call solve_aliases,$(on)),$(dir)/${item})" $(if $(since),since=$(since))
