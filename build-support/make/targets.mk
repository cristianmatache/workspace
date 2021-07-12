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
lang = [[ ! -z "$1" ]] && [[ ! -z `find $(call solve_on,$1) -type f -regex $2` ]]


ifneq ($(since),)
# Filter git diff --name-only output for the right extension and find the path in the original targets such that we:
# 1. ensure the files exist (git diff --name-only also reports files that were deleted)
# 2. ensure we only run the checks over the targets listed in the global $(ON<lang>) not across any changed <lang> file
# Does not work if paths/file names contain spaces, XYZ is some file that does not exist, used to have a value for the final -o
onpy=$(shell find $(call solve_on,$(ONPY))   $(foreach file,$(shell git diff --name-only $(since) | grep -E "*\.pyi?" | grep -v ".pylintrc"), -wholename $(file) -o) -wholename XYZ)
onsh=$(shell find $(call solve_on,$(ONSH))   $(foreach file,$(shell git diff --name-only $(since) | grep -E "*\.sh"), -wholename $(file) -o) -wholename XYZ)
onhs=$(shell find $(call solve_on,$(ONHS))   $(foreach file,$(shell git diff --name-only $(since) | grep -E "*\.hs"), -wholename $(file) -o) -wholename XYZ)
onnb=$(shell find $(call solve_on,$(ONNB))   $(foreach file,$(shell git diff --name-only $(since) | grep -E "*\.ipynb"), -wholename $(file) -o) -wholename XYZ)
onmd=$(shell find $(call solve_on,$(ONMD))   $(foreach file,$(shell git diff --name-only $(since) | grep -E "*\.md"), -wholename $(file) -o) -wholename XYZ)
onyml=$(shell find $(call solve_on,$(ONYML)) $(foreach file,$(shell git diff --name-only $(since) | grep -E "*\.ya?ml"), -wholename $(file) -o) -wholename XYZ)
else
onpy=$(ONPY)
onsh=$(ONSH)
onhs=$(ONHS)
onnb=$(ONNB)
onmd=$(ONMD)
onyml=$(ONYML)
endif

# $1 = on
# $1 = on
# $2 = since
#solve_since = $(shell find $(call solve_on,$1) -regextype posix-egrep -regex "$$(git diff --name-only $2 | head -c -1 | awk '{print "./"$$0 }' | tr '\n' '|' | awk '{print "("$$0")"}')")
