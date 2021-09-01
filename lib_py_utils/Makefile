# Inner Makefile example
SHELL := /bin/bash

# Targets - for formatting, linting, type-checking, testing
ONPY=py_utils/ test_utils/

include ../build-support/make/core/targets.mk  # Utilities to resolve targets

include ../build-support/make/core/python/setup.mk
MYPY_CONFIG="invalid"
include ../build-support/make/core/python/type-check.mk
