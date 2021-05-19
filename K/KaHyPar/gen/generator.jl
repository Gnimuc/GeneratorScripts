using Clang.Generators
using Clang.Generators.JLLEnvs
using KaHyPar_jll

cd(@__DIR__)

target = "x86_64-linux-gnu"

KaHyPar_inc = JLLEnvs.get_pkg_include_dir(KaHyPar_jll, target)

args = get_default_args(target)

headers = detect_headers(KaHyPar_inc, args)

options = load_options(joinpath(@__DIR__, "generator.toml"))

ctx = create_context(headers, args, options)

build!(ctx)
