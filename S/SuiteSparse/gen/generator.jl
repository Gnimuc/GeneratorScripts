#! /bin/bash julia --project generator.jl
using Pkg
using Pkg.Artifacts
using Clang.Generators
using Clang.Generators.JLLEnvs
using SuiteSparse_jll

cd(@__DIR__)

# headers
SuiteSparse_toml = joinpath(dirname(Pkg.pathof(SuiteSparse_jll)), "..", "StdlibArtifacts.toml")
SuiteSparse_dir = Pkg.Artifacts.ensure_artifact_installed("SuiteSparse", SuiteSparse_toml)

include_dir = joinpath(SuiteSparse_dir, "include") |> normpath
cholmod_h = joinpath(include_dir, "cholmod.h")
@assert isfile(cholmod_h)

cholmod_blas_h = joinpath(include_dir, "cholmod_blas.h")
@assert isfile(cholmod_blas_h)

SuiteSparseQR_C_h = joinpath(include_dir, "SuiteSparseQR_C.h")
@assert isfile(SuiteSparseQR_C_h)

umfpack_h = joinpath(include_dir, "umfpack.h")
@assert isfile(umfpack_h)

# load common option
options = load_options(joinpath(@__DIR__, "generator.toml"))

# run generator for all platforms
for target in JLLEnvs.JLL_ENV_TRIPLES
    @info "processing $target"

    options["general"]["output_file_path"] = joinpath(@__DIR__, "..", "lib", "$target.jl")

    args = get_default_args(target)
    push!(args, "-I$include_dir")
    if startswith(target, "x86_64") || startswith(target, "powerpc64le") || startswith(target, "aarch64")
        push!(args, "-DSUN64 -DLONGBLAS='long long'")
    end

    header_files = [cholmod_h, cholmod_blas_h, SuiteSparseQR_C_h, umfpack_h]

    ctx = create_context(header_files, args, options)

    build!(ctx)
end
