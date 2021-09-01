DEFAULT_PYTHON_ENV='3rdparty/py-env-ws'

# Common args
line_len=120

# Config files
MYPY_CONFIG=build-support/python/tools-config/mypy.ini
PYLINT_CONFIG=build-support/python/tools-config/.pylintrc
FLAKE8_CONFIG=build-support/python/tools-config/.flake8
ISORT_CONFIG=build-support/python/tools-config/pyproject.toml
BLACK_CONFIG=build-support/python/tools-config/pyproject.toml
BANDIT_CONFIG=build-support/python/tools-config/.bandit.yml
PYTEST_CONFIG=build-support/python/tools-config/pyproject.toml
FLAKE8_NB_CONFIG=build-support/jupyter/tools-config/.flake8_nb

# Tools config
DEFAULT_PYTEST_MARKS=""
DEFAULT_THIRD_PARTY_DEPS_FILE=3rdparty/py-env-ws/requirements.txt
DEFAULT_FIRST_PARTY_DEPS_FILE=build-support/python/packaging/first-party-libs.txt
