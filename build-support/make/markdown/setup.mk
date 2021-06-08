WS_MD_ENV=3rdparty/md-env-ws
NPM_DEV_MD_DEPS=$(WS_MD_ENV)/npm-dev-deps.txt


env-md: env-md-ws-replicate

env-md-ws-create:
	cat $(NPM_DEV_MD_DEPS) | tr -d "\r" | xargs npm --prefix $(WS_MD_ENV) install --save-dev

env-md-ws-replicate:
	npm --prefix $(WS_MD_ENV) ci
