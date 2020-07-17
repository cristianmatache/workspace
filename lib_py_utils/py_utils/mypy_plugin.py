"""
Type partialmethod based on: returns.contrib.mypy.returns_plugin
"""
# pylint: disable=no-name-in-module
from typing import Callable, ClassVar, Mapping, Optional, Type

from mypy.checker import TypeChecker
from mypy.plugin import FunctionContext, MethodContext, Plugin
from mypy.typeops import coerce_to_literal
from mypy.types import Type as MypyType, CallableType, LiteralType
from returns.contrib.mypy.returns_plugin import partial
from typing_extensions import Final, final

#: Used for typed ``partialmethod`` function.
_TYPED_PARTIAL_FUNCTION: Final = 'py_utils.functools.partialmethod'


# Type aliases
# ============

#: Type for a function hook.
_FunctionCallback = Callable[[FunctionContext], MypyType]

#: Type for a method hook.
_MethodCallback = Callable[[MethodContext], MypyType]


def partialmethod_analyze(ctx: FunctionContext) -> MypyType:
    # Func type
    func_type = ctx.arg_types[0][0]
    assert isinstance(func_type, CallableType)
    func_args_to_type = dict(zip(func_type.arg_names, func_type.arg_types))
    # Applied
    applied_names, applied_types = ctx.arg_names[1:][0], ctx.arg_types[1:][0]
    applied_args_to_types = dict(zip(applied_names, applied_types))
    # api: TypeChecker = ctx.api
    # for applied_arg, applied_arg_type in applied_args_to_types.items():
    #     literalized_applied_type = coerce_to_literal(applied_arg_type)
    #     print(literalized_applied_type, '->', func_args_to_type[applied_arg])
    #     print('-' * 10)
    #     api.check_subtype(literalized_applied_type, func_args_to_type[applied_arg], ctx.context)
    return partial.analyze(ctx)


@final
class CristianPlugin(Plugin):
    """Our main plugin to dispatch different callbacks to specific features."""

    _function_hook_plugins: ClassVar[Mapping[str, _FunctionCallback]] = {
        _TYPED_PARTIAL_FUNCTION: partialmethod_analyze,
    }

    def get_function_hook(self, fullname: str) -> Optional[_FunctionCallback]:
        """
        Called for function return types from ``mypy``.

        Runs on each function call in the source code.
        We are only interested in a particular subset of all functions.
        So, we return a function handler for them.

        Otherwise, we return ``None``.
        """
        return self._function_hook_plugins.get(fullname)


def plugin(version: str) -> Type[Plugin]:  # pylint: disable=unused-argument # noqa
    """Plugin's public API and entrypoint."""
    return CristianPlugin
