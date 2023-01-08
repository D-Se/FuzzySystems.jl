module FuzzyLogic

include("utils.jl")             # macros
include("exceptions.jl")

include("negation.jl")
include("T-norm.jl")
include("S-norm.jl")
include("implication.jl")
include("membership.jl")
include("defuzz.jl")

include("logic.jl")


export 
    gaussian, bell, triangular, trapezoid, sigmoid, lins, singleton, Pi, Z, S,
    μ,
    logic
end
