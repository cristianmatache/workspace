lint-py: flake8 bandit fmt-check-py pylint

fmt-check-py: autoflake-check docformatter-check isort-check black-check flynt-check

autoflake-check:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m autoflake --in-place --remove-all-unused-imports --check -r $(call solve_on,$(on)); fi

docformatter-check: docformatter-diff docformatter-actual-check

docformatter-actual-check:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) --check -r $(call solve_on,$(on)); fi

docformatter-diff:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m docformatter --wrap-summaries=$(line_len) --wrap-descriptions=$(line_len) -r $(call solve_on,$(on)); fi

isort-check:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m isort --diff --color --check-only --settings-path $(ISORT_CONFIG) $(line_len) $(call solve_on,$(on)); fi

black-check:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m black -S --check --config $(BLACK_CONFIG) $(call solve_on,$(on)); fi

flynt-check:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m flynt --dry-run --fail-on-change $(call solve_on,$(on)); fi

flake8:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m flake8 --config=$(FLAKE8_CONFIG) $(call solve_on,$(on)); fi

bandit:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m bandit --configfile $(BANDIT_CONFIG) -r $(call solve_on,$(on)); fi

pylint:
	$(eval on := $(onpy))
	if $(call lang,$(on),".*\.pyi?"); then  \
	python -m pylint --rcfile=$(PYLINT_CONFIG) $(call solve_on,$(on)); fi
