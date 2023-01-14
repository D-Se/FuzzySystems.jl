module FuzzyLogic

include("utils.jl")
include("exceptions.jl")

include("setops.jl")
include("implication.jl")

include("membership.jl")
include("rule.jl")

include("defuzz.jl")

include("logic.jl")


export
    # membership structures
    Gaussian, Bell, Triangular, Trapezoid, Sigmoid,
    Lins, Linz, Singleton, Pi, Z_shape, S_shape,

    μ,

    logic
end
