lint-py: flake8 autoflake-check docformatter-check isort-check black-check bandit pylint

autoflake-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m autoflake --in-place --remove-all-unused-imports --check -r $(call solve_on,$(on)); fi
#	$(call smart_command,"autoflake --in-place --remove-all-unused-imports --check -r",$(call solve_on,$(on)))
else
	python -m autoflake --in-place --remove-all-unused-imports --check -r $(call solve_since,$(since),".py")
#	$(call smart_command,"autoflake --in-place --remove-all-unused-imports --check -r",$(call solve_since,$(since),".py"))
endif

docformatter-check: docformatter-diff docformatter-actual-check

docformatter-actual-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(call solve_on,$(on)); fi
else
	python -m docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r",$(call solve_on,$(on)))

docformatter-diff:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on)); fi
else
	python -m docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r")

isort-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m isort --diff --color --check-only --settings-path $(ISORT_CONFIG) $(line_len) $(call solve_on,$(on)); fi
else
	python -m isort --diff --color --check-only --settings-path $(ISORT_CONFIG) $(line_len) $(call solve_since,$(since),".py")
endif
#$(call smart_command,"isort --diff --color --check-only -m 2 -l $(line_len)")

black-check:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m black --check --config $(BLACK_CONFIG) $(call solve_on,$(on)); fi
else
	python -m black --check --config $(BLACK_CONFIG) $(call solve_since,$(since),".py")
endif

flake8:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m flake8 --config=$(FLAKE8_CONFIG) $(call solve_on,$(on)); fi
else
	if $(call lang,$(call solve_since,$(since),".py"),".*\.pyi?"); then \
	python -m flake8 --config=$(FLAKE8_CONFIG) $(call solve_since,$(since),".py"); fi
endif
#$(call smart_command,"flake8 --config=build-support/.flake8")

bandit:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m bandit --configfile $(BANDIT_CONFIG) -r $(call solve_on,$(on)); fi
else
	python -m bandit --configfile $(BANDIT_CONFIG) -r $(call solve_since,$(since),".py")
endif
#$(call smart_command,"bandit --configfile $(BANDIT_CONFIG) -r",$(call solve_on,$(on)))

pylint:
	$(eval on := $(onpy))
ifeq ($(since),)
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m pylint --rcfile=$(PYLINT_CONFIG) $(call solve_on,$(on)); fi
else
	if $(call lang,$(call solve_since,$(since),".py"),".*\.pyi?"); then \
	python -m pylint --rcfile=$(PYLINT_CONFIG) $(call solve_since,$(since),".py"); fi
endif
#$(call smart_command,"pylint --rcfile=$(PYLINT_CONFIG),$(call solve_on,$(on))")
