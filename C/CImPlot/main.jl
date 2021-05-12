# bootstrap
using Pkg
cd(@__DIR__)
Pkg.activate(@__DIR__)
Pkg.develop("Clang")
Pkg.instantiate()

# run generator
include("generator.jl")

# loading generated package
include(options["general"]["output_file_path"])
mod = Symbol(options["general"]["module_name"])
@eval using .$mod
