folders = String[]
for x in readdir(@__DIR__)
    if match(r"[A-Z]", x) !== nothing
        y = joinpath(@__DIR__, x)
        isdir(y) && push!(folders, y)
    end
end

bad_scripts = []
for folder in folders
    for (root, dirs, files) in walkdir(folder)
        for file in files
            if endswith(file, "main.jl")
                @info "processing $file ..."
                try
                    include(joinpath(root, file))
                catch err
                    @error err
                    push!(bad_scripts, joinpath(root, file))
                end
            end
        end
    end
end

!isempty(bad_scripts) && @error bad_scripts
