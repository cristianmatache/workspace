"""Type partialmethod based on: returns.contrib.mypy.returns_plugin."""
# pylint: disable=no-name-in-module
from typing import Callable, ClassVar, Mapping, Optional, Type

from mypy.plugin import FunctionContext, Plugin
from mypy.types import Type as MypyType
from returns.contrib.mypy.returns_plugin import partial
from typing_extensions import Final, final

#: Used for typed ``partialmethod`` function.
_TYPED_PARTIAL_FUNCTION: Final = 'py_utils.functools.partialmethod'


# Type aliases
# ============

#: Type for a function hook.
_FunctionCallback = Callable[[FunctionContext], MypyType]


@final
class CristianPlugin(Plugin):
    """Our main plugin to dispatch different callbacks to specific features."""

    # pylint: disable=too-few-public-methods

    _function_hook_plugins: ClassVar[Mapping[str, _FunctionCallback]] = {
        _TYPED_PARTIAL_FUNCTION: partial.analyze,
    }

    def get_function_hook(self, fullname: str) -> Optional[_FunctionCallback]:
        """Called for function return types from ``mypy``.

        Runs on each function call in the source code.
        We are only interested in a particular subset of all functions.
        So, we return a function handler for them.

        Otherwise, we return ``None``.
        """
        return self._function_hook_plugins.get(fullname)


def plugin(version: str) -> Type[Plugin]:  # pylint: disable=unused-argument # noqa
    """Plugin's public API and entrypoint."""
    return CristianPlugin
