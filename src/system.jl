abstract type AbstractFuzzySystem end

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
        push!(strength, rule.op(tmp_s))
    end
    defuzz(strength, fis)
end
