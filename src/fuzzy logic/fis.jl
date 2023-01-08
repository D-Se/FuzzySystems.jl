struct Rule
    input
    output
    fire_method
    function Rule(input, output, fire_method = "MIN")
        new(input, output, fire_method)
    end
end

struct Mamdani
    input_dict::Vector{Dict{AbstractString, MF}}
    output_dict::Dict{AbstractString, MF}
    rules::Vector{Rule}
end

function eval(fis::Mamdani, input, defuzz_method = "WTAV")
    strength = Float64[]
    for rule in fis.rules
        tmp_strengths = AbstractFloat[]
        for i in eachindex(rule.input)
            if (rule.input[i] !== "")
                push!(tmp_strengths, μ(input[i], fis.input_dict[i][rule.input[i]]))
            end
        end
        push!(strength, firing(tmp_strengths, rule.fire_method))
    end
    defuzz(strength, fis, defuzz_method)
end

function firing(tmp_strengths::Vector{<:AbstractFloat}, firing_method::AbstractString)
    if firing_method == "MIN"
        return	minimum(tmp_strengths)
    elseif firing_method == "MAX"
        return	maximum(tmp_strengths)
    end
end