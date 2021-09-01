pip-install-local:
	pip install --no-deps --upgrade $(PY_LIBS)

pip-uninstall-local:
	pip uninstall -y $(PY_LIB_NAMES)

# Run `make pip-install-local` first if you want to include your first party libraries in the output
# on=<> **must** always be supplied because this extracts "imports" from any Python file/package
reqs-py:
	$(eval exclude := "dataclasses")
	$(eval core_3rdparty_reqs_file := $(DEFAULT_THIRD_PARTY_DEPS_FILE))
	$(eval core_1stparty_reqs_file := $(DEFAULT_FIRST_PARTY_DEPS_FILE))
	reqs=$$(pipreqs --no-pin --print --use-local $(on) | grep -iv $(exclude) | sort | tr -d "\r" | tr "\n" "|" | awk '{print substr($$1, 1, length($$1)-1)}'); \
	first_p_reqs=$$(cat $(core_1stparty_reqs_file) | awk -v pat="$$reqs" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$0}'); \
	third_p_reqs=$$(cat $(core_3rdparty_reqs_file) | awk -v pat="$$reqs" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$1}'); \
	echo -e "$$first_p_reqs\n$$third_p_reqs" | sort;

# Merging with existing requirements.txt may need manual adjustment because this never removes existing contents
# Use reqs-py to investigate what packages need to be removed
py-libs-reqs-files: pip-install-local
	$(eval on := $(PY_PROJECTS))
	$(eval exclude := "dataclasses")
	$(eval core_3rdparty_reqs_file := $(DEFAULT_THIRD_PARTY_DEPS_FILE))
	$(eval core_1stparty_reqs_file := $(DEFAULT_FIRST_PARTY_DEPS_FILE))
	# internal constants
	$(eval delim := --------------------------------------------------)
	$(eval tmp_fname := tmp-autogenerated-requirements.txt)
	$(eval main_fname := autogenerated-requirements.txt)
	for lib in $$(echo $(on) | sed 's/:/\n/g'); do \
		reqs=$$(pipreqs --no-pin --print --use-local $$lib | grep -iv $(exclude) | sort | tr -d "\r" | tr "\n" "|" | awk '{print substr($$1, 1, length($$1)-1)}'); \
		first_p_reqs=$$(cat $(core_1stparty_reqs_file) | grep -iv "\-\-extra\-index\-url" | awk -v pat="$$reqs" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$0}'); \
		third_p_reqs=$$(cat $(core_3rdparty_reqs_file) | awk -v pat="$$reqs" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$1}'); \
  		echo "$$first_p_reqs" > $$lib/$(tmp_fname); \
  		echo "$$third_p_reqs" >> $$lib/$(tmp_fname); \
  		echo -e "$(delim)\n$$lib\n$(delim)\n$$first_p_reqs\n$$third_p_reqs\n"; \
  		cat $$lib/$(main_fname) $$lib/$(tmp_fname) | sort | dos2unix | uniq > $$lib/$(main_fname); \
  		rm $$lib/$(tmp_fname); \
 	done
