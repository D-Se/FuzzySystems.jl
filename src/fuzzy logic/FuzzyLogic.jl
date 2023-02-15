module FuzzyLogic

import Base: !, &, |, typemin, typemax
foreach(include, (
    "_utils.jl",

    "logic.jl",
    "membership.jl",
    "rule.jl",
    "defuzz.jl",
    "properties.jl",
    "ish.jl",

    "alias.jl"
))

export
    Logic, setlogic!, |, &, !,

    AbstractIsh, 𝙂ish, 𝘼ish, 𝘿ish, 𝙇ish, 𝙁ish,
    ish,

    # t-norms, s-norms & implications
    𝙂ᵗ, 𝘼ᵗ, 𝘿ᵗ, 𝙀ᵗ, 𝙃ᵗ, 𝙇ᵗ, 𝙁ᵗ,
    𝙂ˢ, 𝘼ˢ, 𝘿ˢ, 𝙀ˢ, 𝙃ˢ, 𝙇ˢ, 𝙁ˢ,
    𝙂ⁱ, 𝘼ⁱ, 𝘿ⁱ,         𝙇ⁱ, 𝙁ⁱ,

    # incomplete logics
    KDⁱ, Mⁱ, Rⁱ, DPⁱ, Zⁱ, Zⁱ², Wⁱ, Sⁱ, GRⁱ, Wuⁱ, Yⁱ, largest_R,

    # complement
    negate,

    # membership
    Gaussian, Bell, Triangular, Trapezoid, Sigmoid,
    Lins, Linz, Singleton, Pi, Z_shape, S_shape,
    μ,

    # syntax convenience macros
    Rule, @rule, @rules, @var,

    # logic & properties
    istnorm, issnorm, isimplication, isstrongnegation, isdemorgantriplet, implicationproperties
end
