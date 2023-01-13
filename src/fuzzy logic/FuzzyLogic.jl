module FuzzyLogic

include("utils.jl")             # macros
include("exceptions.jl")

include("negation.jl")
include("T-norm.jl")
include("S-norm.jl")
include("implication.jl")

include("rule.jl")
include("membership.jl")
include("defuzz.jl")

include("logic.jl")


export
    Gaussian, Bell, Triangular, Trapezoid, Sigmoid, Lins, Singleton, Pi, Z, S,

    μ,

    logic
end
