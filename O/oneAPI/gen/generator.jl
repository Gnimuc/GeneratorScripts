using Clang.Generators
using JuliaFormatter
using oneAPI_Level_Zero_Headers_jll

checked_types = [
    "ze_result_t",
]

function add_check_pass(x::Expr)
    Meta.isexpr(x, :function) || return x
    body = x.args[2].args[1]
    if Meta.isexpr(body, :macrocall)  # `@ccall`
        ret_type = string(body.args[3].args[2])
        if ret_type in checked_types
            return Expr(:macrocall, Symbol("@checked"), nothing, x)
        end
    else
        @assert Meta.isexpr(body, :call)  # `ccall`
        ret_type = string(body.args[3])
        if ret_type in checked_types
            return Expr(:macrocall, Symbol("@checked"), nothing, x)
        end
    end
    return x
end

outpath = joinpath(@__DIR__, "..", "src", "LibOneAPI.jl")
options = load_options(joinpath(@__DIR__, "generator.toml"))
options["general"]["output_file_path"] = outpath
options["general"]["prologue_file_path"] = joinpath(@__DIR__, "prologue.jl")

args = get_default_args()

ctx = create_context(oneAPI_Level_Zero_Headers_jll.ze_api, args, options)

build!(ctx, BUILDSTAGE_NO_PRINTING)

for node in get_nodes(ctx.dag)
    exprs = get_exprs(node)
    for (i, expr) in enumerate(exprs)
        exprs[i] = add_check_pass(expr)
    end
end

build!(ctx, BUILDSTAGE_PRINTING_ONLY)

format(outpath, YASStyle(), always_use_return=false)
