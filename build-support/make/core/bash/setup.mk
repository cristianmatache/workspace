env-sh-default-upgrade:
	cat $(NPM_DEV_SH_DEPS) | tr -d "\r" | xargs npm --prefix $(DEFAULT_SH_ENV) install --save-dev
	conda install go-shfmt -c conda-forge -y

env-sh-default-replicate:
	npm --prefix $(DEFAULT_SH_ENV) ci || echo "Check manually if it passes, since it causes make to fail unexpectedly !!!"
	conda install go-shfmt -c conda-forge -y
