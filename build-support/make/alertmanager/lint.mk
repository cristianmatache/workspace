lint-alertmanager: amtool-check-config

# find .. --exec always has exit code 0 -> use find | xargs
amtool-check-config:
	$(eval on := $(onam))
	$(eval amhome := $(shell source lib_sh_utils/src/commands.sh && find_command_home alertmanager ~/alertmanager/ ALERTMANAGER_HOME))
ifeq ($(since),)
	if $(call lang,$(on),".*alertmanager/.*\.yml"); then \
	find $(call solve_on,$(on)) -type f -regex ".*alertmanager.*\.yml" | xargs --no-run-if-empty "$(amhome)/amtool" check-config; fi
else
	find $(call solve_since,$(since),".yml") -type f -regex ".*alertmanager.*\.yml" | xargs --no-run-if-empty "$(amhome)/amtool" check-config;
endif
