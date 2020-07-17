# TODO: do proper testing with yml and # E:
from typing import TypeVar, Type, Sequence

from typing_extensions import Literal

from py_utils.functools import partialmethod

T = TypeVar('T', bound='Child2')


class Base:
    pass


class Child1(Base):
    pass


class Child2(Base):
    pass


class TestClass:

    def my_method(self, arg1: int, arg2: Type[Base], arg3: Literal[1, 2], arg4: Sequence[T]) -> T:
        print(self, arg1, arg2, arg3)
        return arg4[0]

    part1 = partialmethod(my_method, arg1=1)
    part2 = partialmethod(my_method, arg2=Child1)
    part3 = partialmethod(my_method, arg3=1)
    part4 = partialmethod(my_method, arg4=[Child2()])
    part4_ = partialmethod(my_method, arg4=Child1())  # type: ignore # ERRORS
    part14 = partialmethod(my_method, arg1=1, arg4=[Child2()])
    part13 = partialmethod(my_method, arg1=1, arg3=2)


cls_full = TestClass.my_method
cls_part = TestClass.part1
TEST_CLASS = TestClass()
full = TEST_CLASS.my_method
part1 = TEST_CLASS.part1
part2 = TEST_CLASS.part2
part3 = TEST_CLASS.part3
part4 = TEST_CLASS.part4
part4_ = TEST_CLASS.part4_
part14 = TEST_CLASS.part14
part13 = TEST_CLASS.part13

res1 = part1(arg2=Child2, arg3=2, arg4=[Child2()])
res2 = part2(arg1=10, arg3=1, arg4=[Child2()])
reveal_locals()
