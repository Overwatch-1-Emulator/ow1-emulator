"""OverPy compile helpers for Bazel."""

load("@npm//:overpy/package_json.bzl", _overpy_bin = "bin")

def overpy_compile(name, main, srcs, out, visibility = None, **kwargs):
    """Compile OverPy sources to Workshop code using the hermetic overpy CLI.

    Args:
        name: Target name.
        main: Label/path of the main `.opy` entry file (e.g. `src/main.opy`).
        srcs: All OverPy sources needed for includes (typically `glob(["src/**/*.opy"])`).
        out: Output Workshop text file name (e.g. `gamemode.txt`).
        visibility: Target visibility.
        **kwargs: Forwarded to the underlying overpy js_run_binary rule.
    """

    # Deduplicate main if it already appears in srcs.
    all_srcs = []
    seen = {}
    for src in srcs + [main]:
        if src not in seen:
            seen[src] = True
            all_srcs.append(src)

    _overpy_bin.overpy(
        name = name,
        srcs = all_srcs,
        outs = [out],
        args = [
            "compile",
            "-i",
            "$(rootpath {})".format(main),
            "-o",
            out,
        ],
        chdir = native.package_name(),
        visibility = visibility,
        **kwargs
    )
