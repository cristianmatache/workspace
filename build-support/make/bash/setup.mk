WS_SH_ENV=3rdparty/sh-env-ws
NPM_DEV_SH_DEPS=$(WS_SH_ENV)/npm-dev-deps.txt


env-sh: env-sh-ws-replicate

env-sh-ws-create:
	cat $(NPM_DEV_SH_DEPS) | tr -d "\r" | xargs npm --prefix $(WS_SH_ENV) install --save-dev

env-sh-ws-replicate:
	npm --prefix $(WS_SH_ENV) ci
