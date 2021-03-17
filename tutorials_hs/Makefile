MAKEFLAGS += -j4

# Subsystems (i.e. inner projects with their own Makefiles)
subsystems=""

# Aliases
iqor=app_iqor/

# All projects
onhs=scheme_interpreter h99
export


lint: hlint

hlint:
	$(eval on := $(onhs))
	hlint $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on)))

shellcheck:
	$(eval on := $(onsh))
	find $(foreach dir, $(on), $(or ${$(dir)},${dir},$(on))) -type f -iname "*.sh" -exec shellcheck --format=gcc -e SC1017 {} \;
