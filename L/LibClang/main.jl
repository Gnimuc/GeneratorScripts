# bootstrap
using Pkg
cd(@__DIR__)
Pkg.activate(@__DIR__)
Pkg.develop("Clang")
Pkg.instantiate()
Pkg.status()

# run generator
include("generator.jl")

# loading generated package
include(joinpath(@__DIR__, "LibClang.jl"))
using .LibClang
