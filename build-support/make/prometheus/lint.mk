lint-prometheus: promtool-check-rules

# find .. --exec always has exit code 0 -> use find | xargs
promtool-check-rules:
	$(eval on := $(onprometheus-rules))
	$(eval promhome := $(shell source lib_sh_utils/commands.sh && find_command_home prometheus ~/prometheus PROMETHEUS_HOME))
ifeq ($(since),)
	if $(call lang,$(on),".*prometheus/rules.*\.yml"); then \
	find $(call solve_on,$(on)) -type f -regex ".*prometheus/rules.*\.yml" | xargs "$(promhome)/promtool" check rules; fi
else
	find $(call solve_since,$(since),".yml") -type f -regex ".*prometheus/rules.*\.yml" | xargs "$(promhome)/promtool" check rules;
endif

#find /d/workspace/workspace/deploy-support/prometheus/rules/ -name *.yml | xargs ~/prometheus/promtool check rules