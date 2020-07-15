from datetime import datetime
from logging import Logger as LoggingLogger, getLogger, CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET, basicConfig
from os import getpid, mkdir
from pathlib import Path
from traceback import format_exc
from typing import ClassVar, Optional, Union, Dict
from warnings import warn

from colorama import Fore, Style

DEFAULT_LOGGER_FORMAT = '%(gmttime)s [%(name)s] %(levelname)s: %(message)s'
DEFAULT_PRINT_PREFIX_FORMAT = '%(color)s %(utcnow)s [%(name)s PID:%(pid)s] %(levelname)s:'

LOG_LEVELS = [CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET]
LEVEL_NAMES = {
    CRITICAL: 'FATAL',
    ERROR: 'ERROR',
    WARNING: 'WARN',
    INFO: 'INFO',
    DEBUG: 'DEBUG',
}
DEFAULT_LEVEL_COLORS = {
    CRITICAL: Fore.RED,
    ERROR: Fore.LIGHTRED_EX,
    WARNING: Fore.MAGENTA,
    INFO: Fore.BLUE,
    DEBUG: Fore.WHITE,
}


class Logger:
    """
    Logging mixin. If the logging module is not initialized it falls back to printing (in a different color per level).

    Usage examples:
        class X(Logger):

            def f(self):
                self._log_info('a')
                self._log_debug('a')
                try:
                    raise ValueError('e')
                except ValueError as exc:
                    self._log_exception(exc)

            @classmethod
            def g(cls):
                cls._log_critical('a')
                cls._log_error('a')
                cls._log_warning(f'{Fore.GREEN}a{Style.RESET_ALL}')

    Initialization:
        - No initialization means printing (at all levels >= DEBUG)
        - Log initialization: Logger.initialize_log(INFO)
        - Print initialization: Logger.initialize_print(INFO)  # Not recommended

    Can be used in regular methods and class methods, cannot be used in static methods.
    """
    __colors: ClassVar[Dict[int, str]] = DEFAULT_LEVEL_COLORS
    __log_is_initialized: ClassVar[bool] = False
    __log_is_colored: ClassVar[bool] = True  # Whether console to color log messages by level by default
    __print_level: ClassVar[int] = DEBUG
    __print_prefix_format: ClassVar[str] = DEFAULT_PRINT_PREFIX_FORMAT

    @classmethod
    def initialize_log(
            cls, level: int, logger_format: str = DEFAULT_LOGGER_FORMAT, log_dir: Optional[Union[Path, str]] = None,
            *, is_colored: bool = True, color_overrides: Optional[Dict[int, str]] = None
    ) -> None:
        assert level in LOG_LEVELS
        # TODO: add console handle
        if log_dir is not None:
            log_dir = Path(log_dir) / 'logs'
            if not log_dir.exists():
                mkdir(log_dir)
            # TODO: add file handler

        basicConfig(format=logger_format)
        cls.__log_is_initialized = True
        cls.__log_is_colored = is_colored
        if color_overrides is not None:
            cls.__colors = {**cls.__colors, **color_overrides}

    @classmethod
    def initialize_print(
            cls, level: int, prefix_format: str = DEFAULT_PRINT_PREFIX_FORMAT,
            color_overrides: Optional[Dict[int, str]] = None
    ) -> None:
        assert not cls.__log_is_initialized, 'Logger is already initialized'
        warn('Initializing printing instead of logging. It is recommended to use logging.')
        cls.__print_level = level
        cls.__print_prefix_format = prefix_format
        if color_overrides is not None:
            cls.__colors = {**cls.__colors, **color_overrides}

    @classmethod
    def __logger_name(cls) -> str:
        return f'{cls.__module__}.{cls.__name__}'

    @classmethod
    def __logger(cls) -> LoggingLogger:
        """Returns a logger."""
        return getLogger(cls.__logger_name())

    @classmethod
    def __print(cls, level: int, *messages: str) -> None:
        assert level in LOG_LEVELS
        if level < cls.__print_level or cls.__print_level == NOTSET:
            return

        prefix = cls.__print_prefix_format % {
            'color': cls.__colors[level],
            'utcnow': datetime.utcnow(),
            'name': cls.__logger_name(),
            'pid': getpid(),
            'levelname': LEVEL_NAMES[level]
        }

        print(prefix, *messages, Style.RESET_ALL)

    @classmethod
    def __log_fallback_print(cls, level: int, message: str) -> None:
        assert level in LOG_LEVELS
        log_message = f'{cls.__colors[level]}{message}{Style.RESET_ALL}' if cls.__log_is_colored else message
        if cls.__log_is_initialized:
            cls.__logger().log(level, log_message)
        else:
            cls.__print(level, message)

    @classmethod
    def _log_critical(cls, message: str) -> None:
        cls.__log_fallback_print(CRITICAL, message)

    @classmethod
    def _log_fatal(cls, message: str) -> None:
        return cls._log_critical(message)

    @classmethod
    def _log_error(cls, message: str) -> None:
        cls.__log_fallback_print(ERROR, message)

    @classmethod
    def _log_exception(cls, message: Union[str, Exception]) -> None:
        if cls.__log_is_initialized:
            cls.__logger().exception(message)
        else:
            cls.__print(ERROR, format_exc(), str(message))

    @classmethod
    def _log_warning(cls, message: str) -> None:
        cls.__log_fallback_print(WARNING, message)

    @classmethod
    def _log_info(cls, message: str) -> None:
        cls.__log_fallback_print(INFO, message)

    @classmethod
    def _log_debug(cls, message: str) -> None:
        cls.__log_fallback_print(DEBUG, message)
