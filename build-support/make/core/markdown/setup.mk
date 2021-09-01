env-md-default-upgrade:
	cat $(DEFAULT_NPM_DEV_MD_DEPS) | tr -d "\r" | xargs npm --prefix $(DEFAULT_MD_ENV) install --save-dev  --registry=https://registry.npmjs.org

env-md-default-replicate:
	npm --prefix $(DEFAULT_MD_ENV) ci --registry=https://registry.npmjs.org || echo "Check manually if it passes, since it causes make to fail unexpectedly !!!"
