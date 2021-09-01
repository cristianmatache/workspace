env-md-default-upgrade:
	cat $(DEFAULT_NPM_DEV_MD_DEPS) | tr -d "\r" | xargs npm --prefix $(DEFAULT_MD_ENV) install --save-dev

env-md-default-replicate:
	npm --prefix $(DEFAULT_MD_ENV) ci || echo "Check manually if it passes, since it causes make to fail unexpectedly !!!"
