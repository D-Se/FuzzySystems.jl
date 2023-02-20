module FuzzyLogic

import Base: !, &, |, Bool, ==, <, <=, xor, isless
using MacroTools: postwalk
foreach(include, (
    "_utils.jl",

    "membership.jl",
    "rule.jl",
    "defuzz.jl",
    "properties.jl",
    "abstractish.jl",
    "logic.jl",

    "alias.jl"
))

export
    Logic, setlogic!, |, &, !, ⟹,

    AbstractIsh, 𝙂ish, 𝘼ish, 𝘿ish, 𝙇ish, 𝙁ish,
    ish,

    Gödel_Dumett, Algebraic, Drastic, Łukasiewicz, Fodor, Einstein, Hamacher,

    # Separate implications
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
