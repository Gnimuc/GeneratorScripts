using Pkg
using Pkg.Artifacts
using Clang.Generators
using Clang.Generators.JLLEnvs
using LibCURL_jll

cd(@__DIR__)

artifact_toml = joinpath(dirname(Pkg.pathof(LibCURL_jll)), "..", "StdlibArtifacts.toml")
artifact_dir = Pkg.Artifacts.ensure_artifact_installed("LibCURL", artifact_toml)

include_dir = joinpath(artifact_dir, "include") |> normpath
curl_h = joinpath(include_dir, "curl", "curl.h")
@assert isfile(curl_h)

# mprintf_h = joinpath(include_dir, "curl", "mprintf.h")
# stdcheaders_h = joinpath(include_dir, "curl", "stdcheaders.h")

for target in JLLEnvs.JLL_ENV_TRIPLES
    @info "processing $target"

    # programmatically add options
    options = Dict{String,Any}("general" => Dict{String,Any}())
    general = options["general"]
    general["library_name"] = "libcurl"
    general["output_file_path"] = joinpath(@__DIR__, "..", "lib", "$target.jl")
    general["use_julia_native_enum_type"] = true
    general["auto_mutability"] = true
    general["use_deterministic_symbol"] = true
    general["printer_blacklist"] = [
        "CURL_SUFFIX_CURL_OFF_T",
        "CURL_SUFFIX_CURL_OFF_TU",
        "CURL_ZERO_TERMINATED",
        ]

    args = get_default_args(target)
    push!(args, "-I$include_dir")

    # header_files = detect_headers(include_dir, args)
    header_files = [curl_h]

    ctx = create_context(header_files, args, options)

    build!(ctx)
end
