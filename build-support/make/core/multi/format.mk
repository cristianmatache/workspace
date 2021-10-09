# !!! Don't edit this file !!!
# This file is part of AlphaBuild core, don't edit it in a repo other than https://github.com/cristianmatache/alpha-build/
# Please submit an issue/pull request to the main repo if you need any changes in the core infrastructure.
# Before doing that, you may wish to consider:
# - updating the config files in build-support/make/config/ to configure tools for your own use case
# - writing a new custom rule, in build-support/make/extensions/<lang>/ and import it in the main Makefile

.PHONY: prettier-check
prettier:
	$(eval targets := $(onmd) $(onyml) $(onjs) $(onts) $(oncss))
	$(eval prettier := $(PRETTIER_BIN))
	if $(call lang,$(targets),$(REGEX_MD)) | $(call lang,$(targets),$(REGEX_YML)) | $(call lang,$(targets),$(REGEX_JS)) | \
	$(call lang,$(targets),$(REGEX_JS)) | $(call lang,$(targets),$(REGEX_TS)) | $(call lang,$(targets),$(REGEX_CSS)) ; then \
	$(prettier) $(PRETTIER_FLAGS) $(call uniq,$(targets)); fi;

.PHONY: dos2unix
dos2unix:
	$(eval targets := $(onpy) $(onsh) $(onhs) $(onnb) $(onmd) $(onyml) $(onjs) $(onts) $(oncss))
	$(eval prettier := $(PRETTIER_BIN))
	if $(call lang,$(targets),$(REGEX_PY)) | $(call lang,$(targets),$(REGEX_SH)) | $(call lang,$(targets),$(REGEX_HS)) | \
	$(call lang,$(targets),$(REGEX_NB)) | \
	$(call lang,$(targets),$(REGEX_MD)) | $(call lang,$(targets),$(REGEX_YML)) | $(call lang,$(targets),$(REGEX_JS)) | \
	$(call lang,$(targets),$(REGEX_JS)) | $(call lang,$(targets),$(REGEX_TS)) | $(call lang,$(targets),$(REGEX_CSS)) ; then \
	find $(call uniq,$(targets)) -type f -regex $(REGEX_YML) | xargs --no-run-if-empty dos2unix; fi;
