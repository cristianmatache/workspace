load("@rules_python//python:defs.bzl", "py_binary")
load("@my_deps//:requirements.bzl", "requirement")

EXTRA_DEPS = {
    "pathos": [
        "ppft"
    ]
}

def _remove_duplicates(list_):
    """Not efficient but Starlark does not have hash sets and list_ should be small"""
    res = []
    for item in list_:
        if item not in res:
            res.append(item)
    return res

def _add_extra_deps(deps):
    """
    There is a (temporary) known problem that some requirement("...") deps do not include all their transitive deps
    (but all pip deps are pip installed already). Hence, we add the missing deps as specified by EXTRA_DEPS.
    Note that EXTRA_DEPS must contain all the transitive deps per package. Since Starlark does not support either
    while or recursion we build these extra deps with the python script full_deps.py which stores the top level deps
    between packages, converts this into all transitive deps per package and paste it in here.
    """
    res_deps = deps
    for dep, dep_deps in EXTRA_DEPS.items():
        if requirement(dep) in deps:
            res_deps += [requirement(dep_dep) for dep_dep in dep_deps]
    return _remove_duplicates(res_deps)

def py_binary_(name, srcs, deps, **kwargs):
    """py_binary enriched with extra deps"""
    return py_binary(name=name, srcs=srcs, deps=_add_extra_deps(deps), **kwargs)

def py_library_(name, srcs, deps, **kwargs):
    """py_library enriched with extra deps"""
    return py_library(name=name, srcs=srcs, deps=_add_extra_deps(deps), **kwargs)