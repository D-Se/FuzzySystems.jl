"""
    AbstractFuzzySystem

An abstract type for which concrete types expose an interface for working with fuzzy systems.

FuzzySystems.jl defines two subtypes of `AbstractFuzzySystem`:
Mamdani and Sugeno.
"""
abstract type AbstractFuzzySystem end

"""
# Keyword arguments
- `logic`
- `rulebase`
- `engine`
- `universe`
"""
mutable struct FuzzySystem <: AbstractFuzzySystem
    logic
    rulebase
    engine
    universe
    function FuzzySystem(logic, rulebase, engine, universe)
        new(logic, rulebase, engine, universe)
    end
end

struct Mamdani
    input_dict::Tuple{Vararg{Dict{Symbol, AbstractMember}}}
    output_dict::Dict{Symbol, AbstractMember}
    rules::Tuple{Vararg{Rule}}
end

function predict(fis::Mamdani, data, defuzz = WTAV)
    strength = Float64[]
    @inbounds @views for rule in fis.rules
        tmp_s = ntuple(i -> μ(data[i], fis.input_dict[i][rule.in[i]]), length(rule.in))
        #push!(strength, firing(tmp_s, rule.op))
        push!(strength, rule.op(tmp_s))
    end
    defuzz(strength, fis)
end

#= function firing(tmp_strengths::Tuple{Vararg{Float64}}, firing_method::AbstractString)
    if firing_method == "MIN"
        return	minimum(tmp_strengths)
    elseif firing_method == "MAX"
        return	maximum(tmp_strengths)
    end
end
 =#
