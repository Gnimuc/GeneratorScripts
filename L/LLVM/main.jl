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
include(joinpath(@__DIR__, "libLLVM_h.jl"))
using .libLLVM_h
