# bootstrap
using Pkg
cd(@__DIR__)
Pkg.activate(@__DIR__)
Pkg.develop("Clang")
Pkg.instantiate()
Pkg.status()

# run generator
include("gen/generator.jl")

# loading generated package
include(joinpath(@__DIR__, "src", "LibSDL2.jl"))
using .LibSDL2
