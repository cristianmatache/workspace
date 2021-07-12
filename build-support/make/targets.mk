# If "on" was supplied as an alias -> solve the alias, otherwise pass in the raw on
# Args:
#	- on: named file/dir target(s) specifier
solve_on = $(foreach target,$(foreach dir, $1, $(or ${$(dir)},${dir},$1)),$(call sanitize,${target}))

# Sanitize double/single/no quotes
ifneq ($(shell uname | egrep -i "msys"),)  # is cmd
sanitize = $(foreach target,$(shell echo $1 | tr '\\\\\\\\' '/' | tr -d "'" | tr -d '"' ),"$(target)")
else  # is Unix or Git bash
sanitize = $1
endif

# Only run the command if the "on" specs are suitable for the expected language
# Args:
#   - on: "on" specifier
#   - $2: file extension regex e.g. ".*\.pyi?" or ".*\.sh"
lang = [[ ! -z `find $(call solve_on,$1) -type f -regex $2` ]]

files_that_exist = $(shell if [[ ! -z "$1" ]]; then echo "$1" | xargs find 2>/dev/null; else echo /dev/null; fi)

## Keep old implementation just in case
#define solve_since
#	$(shell if [ -z $(git diff --name-only $1 | grep -F "$2" ) ]; then echo ".gitignore"; else git diff --name-only $1 | grep -F "$2" | xargs -d'\n' find 2>/dev/null | tr '\n' ' ' | echo; fi)
#endef