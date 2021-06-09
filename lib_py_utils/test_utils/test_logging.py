from logging import DEBUG, ERROR, FATAL, WARN

from colorama import Fore
from pytest import raises, warns

from py_utils.logging import Logger


class MyClass(Logger):
    def method(self, arg: int) -> None:
        self._log_debug(f'Debug: {arg}')
        self._log_info(f'Info: {arg}')
        self._log_warning(f'Warn: {arg}')
        self._log_critical(f'Critical: {arg}')
        self._log_error(f'Error: {arg}')
        self._log_fatal(f'Fatal: {arg}')
        try:
            raise ValueError('Log method')
        except ValueError as exc:
            self._log_exception(exc)

    @classmethod
    def cls_method(cls, arg: int) -> None:
        cls._log_debug(f'Debug: {arg}')
        cls._log_fatal(f'Fatal: {arg}')
        try:
            raise ValueError('Log classmethod')
        except ValueError as exc:
            cls._log_exception(exc)


def test_logger_print() -> None:
    # No initialization -> print -> default level is DEBUG
    my_class = MyClass()

    my_class.method(10)
    my_class.cls_method(100)

    # With initialization
    with warns(UserWarning):
        Logger.initialize_print(level=WARN, prefix_format="Cristian's %(pid)s", color_overrides={FATAL: Fore.GREEN})
    my_class.method(10)
    my_class.cls_method(100)

    # Reinitializing printing is allowed
    with warns(UserWarning):
        Logger.initialize_print(level=ERROR, is_colored=False)
    my_class.cls_method(10)


def test_logger_log() -> None:
    # No initialization -> print -> default level is DEBUG
    Logger.initialize_log(level=DEBUG, log_file=None)
    my_class = MyClass()

    my_class.method(10)
    my_class.cls_method(100)

    # Reinitializing logging is not allowed
    with raises(AssertionError):
        Logger.initialize_print(level=ERROR, is_colored=False)
