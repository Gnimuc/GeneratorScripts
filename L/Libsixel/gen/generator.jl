using Clang.Generators
using libsixel_jll

cd(@__DIR__)

include_dir = joinpath(libsixel_jll.artifact_dir, "include") |> normpath

options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-I$include_dir")

headers = detect_headers(include_dir, args)

ctx = create_context(headers, args, options)

build!(ctx)
