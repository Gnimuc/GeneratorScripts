module LibKaHyPar

using KaHyPar_jll
export KaHyPar_jll

mutable struct kahypar_context_s end

const kahypar_context_t = kahypar_context_s

const kahypar_hypernode_id_t = Cuint

const kahypar_hyperedge_id_t = Cuint

const kahypar_hypernode_weight_t = Cint

const kahypar_hyperedge_weight_t = Cint

const kahypar_partition_id_t = Cuint

# no prototype is found for this function at libkahypar.h:57:32, please use with caution
function kahypar_context_new()
    ccall((:kahypar_context_new, libkahypar), Ptr{kahypar_context_t}, ())
end

function kahypar_context_free(kahypar_context)
    @ccall libkahypar.kahypar_context_free(kahypar_context::Ptr{kahypar_context_t})::Cvoid
end

function kahypar_configure_context_from_file(kahypar_context, ini_file_name)
    @ccall libkahypar.kahypar_configure_context_from_file(kahypar_context::Ptr{kahypar_context_t}, ini_file_name::Ptr{Cchar})::Cvoid
end

function kahypar_set_custom_target_block_weights(num_blocks, block_weights, kahypar_context)
    @ccall libkahypar.kahypar_set_custom_target_block_weights(num_blocks::kahypar_partition_id_t, block_weights::Ptr{kahypar_hypernode_weight_t}, kahypar_context::Ptr{kahypar_context_t})::Cvoid
end

function kahypar_read_hypergraph_from_file(file_name, num_vertices, num_hyperedges, hyperedge_indices, hyperedges, hyperedge_weights, vertex_weights)
    @ccall libkahypar.kahypar_read_hypergraph_from_file(file_name::Ptr{Cchar}, num_vertices::Ptr{kahypar_hypernode_id_t}, num_hyperedges::Ptr{kahypar_hyperedge_id_t}, hyperedge_indices::Ptr{Ptr{Csize_t}}, hyperedges::Ptr{Ptr{kahypar_hyperedge_id_t}}, hyperedge_weights::Ptr{Ptr{kahypar_hyperedge_weight_t}}, vertex_weights::Ptr{Ptr{kahypar_hypernode_weight_t}})::Cvoid
end

function kahypar_partition(num_vertices, num_hyperedges, epsilon, num_blocks, vertex_weights, hyperedge_weights, hyperedge_indices, hyperedges, objective, kahypar_context, partition)
    @ccall libkahypar.kahypar_partition(num_vertices::kahypar_hypernode_id_t, num_hyperedges::kahypar_hyperedge_id_t, epsilon::Cdouble, num_blocks::kahypar_partition_id_t, vertex_weights::Ptr{kahypar_hypernode_weight_t}, hyperedge_weights::Ptr{kahypar_hyperedge_weight_t}, hyperedge_indices::Ptr{Csize_t}, hyperedges::Ptr{kahypar_hyperedge_id_t}, objective::Ptr{kahypar_hyperedge_weight_t}, kahypar_context::Ptr{kahypar_context_t}, partition::Ptr{kahypar_partition_id_t})::Cvoid
end

function kahypar_improve_partition(num_vertices, num_hyperedges, epsilon, num_blocks, vertex_weights, hyperedge_weights, hyperedge_indices, hyperedges, input_partition, num_improvement_iterations, objective, kahypar_context, improved_partition)
    @ccall libkahypar.kahypar_improve_partition(num_vertices::kahypar_hypernode_id_t, num_hyperedges::kahypar_hyperedge_id_t, epsilon::Cdouble, num_blocks::kahypar_partition_id_t, vertex_weights::Ptr{kahypar_hypernode_weight_t}, hyperedge_weights::Ptr{kahypar_hyperedge_weight_t}, hyperedge_indices::Ptr{Csize_t}, hyperedges::Ptr{kahypar_hyperedge_id_t}, input_partition::Ptr{kahypar_partition_id_t}, num_improvement_iterations::Csize_t, objective::Ptr{kahypar_hyperedge_weight_t}, kahypar_context::Ptr{kahypar_context_t}, improved_partition::Ptr{kahypar_partition_id_t})::Cvoid
end

# exports
const PREFIXES = ["kahypar_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
