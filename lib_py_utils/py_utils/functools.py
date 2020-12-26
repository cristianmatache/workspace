from functools import partialmethod as _partialmethod
from typing import Any, Callable, TypeVar, cast

_ReturnType = TypeVar('_ReturnType')


def partialmethod(func: Callable[..., _ReturnType], **kwargs: Any) -> Callable[..., _ReturnType]:
    return cast(Callable[..., _ReturnType], _partialmethod(func, **kwargs))
