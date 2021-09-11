# find .. --exec always has exit code 0 -> use find | xargs
amtool-check-config:
	$(eval on := $(onam))
	$(eval amhome := $(shell source lib_sh_utils/src/commands.sh && find_command_home alertmanager ~/alertmanager/ ALERTMANAGER_HOME))
	if $(call lang,$(targets),".*alertmanager/.*\.yml"); then \
	find $(call solve_aliases,$(on)) -type f -regex ".*alertmanager.*\.yml" | xargs --no-run-if-empty "$(amhome)/amtool" check-config; fi
