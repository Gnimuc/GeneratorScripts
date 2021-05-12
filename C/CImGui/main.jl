# bootstrap
using Pkg
cd(@__DIR__)
Pkg.activate(@__DIR__)
Pkg.develop("Clang")
Pkg.instantiate()

# run generator
include("gen/generator.jl")

# loading generated package
include(joinpath(@__DIR__, "src", "LibCImGui.jl"))
using .LibCImGui
