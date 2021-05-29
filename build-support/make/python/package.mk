package-py: shiv

shiv:
	$(eval on := .)
	find $(on) -type f -name "shiv-package.sh" | sort | xargs bash

reqs-py:
	$(eval exclude := "dataclasses")
	$(eval env := py-env-ws)
	reqs=$$(pipreqs --no-pin --print $(on) | grep -iv $(exclude) | sort); \
	pattern=$$(echo "$$reqs" | tr -d "\r" | tr "\n" "|" | awk '{print substr($$1, 1, length($$1)-1)}'); \
	first_p_reqs=$$(cat build-support/python/packaging/first-party-libs.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$2}'); \
	third_p_reqs=$$(cat 3rdparty/$(env)/requirements.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$1}'); \
	echo -e "$$first_p_reqs\n$$third_p_reqs";

# Merging with existing requirements.txt may need manual adjustment
reqs-py-libs:
	$(eval on := $(SOURCES_ROOTS))
	$(eval exclude := "dataclasses")
	$(eval env := py-env-ws)
	$(eval delim := --------------------------------------------------)
	for lib in $$(echo $(on) | sed 's/:/\n/g'); do \
  		reqs=$$(pipreqs --no-pin --print $$lib | grep -iv $(exclude) | sort); \
  		pattern=$$(echo "$$reqs" | tr -d "\r" | tr "\n" "|" | awk '{print substr($$1, 1, length($$1)-1)}'); \
  		first_p_reqs=$$(cat build-support/python/packaging/first-party-libs.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$2}'); \
  		third_p_reqs=$$(cat 3rdparty/$(env)/requirements.txt | awk -v pat="$$pattern" 'BEGIN {IGNORECASE = 1} ($$0~pat){print $$1}'); \
  		echo "$$first_p_reqs" | sed 's/\ //g' > $$lib/generated-requirements.txt; \
  		echo "$$third_p_reqs" | sed 's/\ //g' >> $$lib/generated-requirements.txt; \
  		echo -e "$$lib\n$(delim)\n$$first_p_reqs\n$$third_p_reqs\n"; \
  		cat $$lib/requirements.txt $$lib/generated-requirements.txt | sort | dos2unix | uniq > $$lib/requirements.txt; \
  		rm $$lib/generated-requirements.txt; \
 	done
