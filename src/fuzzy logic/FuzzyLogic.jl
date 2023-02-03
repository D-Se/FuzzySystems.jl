module FuzzyLogic

foreach(include, (
    "_utils.jl",

    "exceptions.jl",
    "setops.jl",
    "implication.jl",
    "membership.jl",
    "rule.jl",
    "defuzz.jl",
    "logic.jl"
))

export
    # membership structures
    Gaussian, Bell, Triangular, Trapezoid, Sigmoid,
    Lins, Linz, Singleton, Pi, Z_shape, S_shape,

    # t-norms
    ∏_algebraic, bounded_difference, ∏_drastic, ∏_einstein, ∏_hamacher, nilpotent_minimum,

    # s-norms
    ∑_algebraic, ∑_bounded, ∑_drastic, ∑_einstein, ∑_hamacher, ∑_probabilistic, nilpotent_maximum,

    # complement
    negate,

    # implication
    kleene_dienes, mizumoto, gödel, goguen, largest_S, largest_R, zadeh, zadeh_late, weber, gaines_rescher, sharp, fodor, wu, yager, drastic,
    reichenbach, łukasiewicz, dubois_prade,

    # membership
    μ,

    # syntax convenience macros
    Rule, @rule, @rules, @var

    # logic & properties
    istnorm, issnorm, isimplication, isstrongnegation, isdemorgantriplet
end
