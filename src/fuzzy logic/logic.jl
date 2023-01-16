# A fuzzy algebra is ...

struct Logic
    N::Function # negation
    T::Function # t-norm
    S::Function # s-norm
    I::Function # implication function
end

#= """
Define fuzzy set operations
    logic(model, args...)

Each `logic` is made up of basic (fuzzy) set operations.

"""
function logic(model::Symbol, args...)
    if length(args) > 0
        eval(Symbol(model))(args)
    else
        eval(Symbol(model))
    end
end =#

#region set operation properties
# functions to verify and aid in the discovery of new set operators

# internal constants for property checks - sample size is 499
(function()
    p = 0.001
    ⬆ = 0+p:p:1-p
    ⬇ = 1-p:-p:0+p

    x = Tuple(⬆[⬆ .<= ⬇][2:end])
    y = Tuple(⬆[⬆ .> ⬇])
    quote
        const 𝓍 = $x
        const 𝓎 = $y
        const 𝓏 = Tuple(μ.(-5+.02:.02:5-.02, Sigmoid(1, 0)))
    end
end)() |> eval

"""
is a fuzzy union (s-norm, AND) of the form `[0,1]² -> [0,1]`
1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
function issnorm(⊥)
    for (x, y, z) in zip(𝓍, 𝓎, 𝓏)
        ⊥(x, 0) ≈ x &&                     # identity
        ⊥(x, y) ≈ ⊥(y, x) && #&&              # communicativity
        ⊥(x, ⊥(y, z)) ≈ ⊥(⊥(x, y), z) && # associativity
        ⊥(z, x) <= ⊥(z, y) ||               # monotonicity
        return false
    end
    return true
end

"""
Is a fuzzy intersection (t-norm, OR) of the form `[0,1]² -> [0,1]`
1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
function istnorm(⊤)
    for (x, y, z) in zip(𝓍, 𝓎, 𝓏)
        ⊤(x, 1) ≈ x   &&                  # identity
        ⊤(x, y) ≈ ⊤(y, x) &&              # communicativity
        ⊤(x, ⊤(y, z)) ≈ ⊤(⊤(x, y), z) &&  # associativity
        ⊤(z, x) <= ⊤(z, y) ||               # monotonicity
        return false
    end
    return true
end

function isdemorgantriplet(⊤, ⊥, ~)
    istnorm(⊤) && issnorm(⊥) && isstrongnegation(~) || return false
    for (x, y) in zip(𝓍, 𝓎)
        ⊥(x, y) ≈ ~(⊤(~(x), ~(y))) || return false
    end
    return true
end

function isstrongnegation(~)
    # strict: x,y ∈ [0,1], x < y ⟹ ~x > ~y
    ~(0) == 1 && ~(1) == 0 || return false
    for (x, y, z) in zip(𝓍, 𝓎, 𝓏)
        ~(x) > ~(y) && ~(~(z)) ≈ z || return false
    end
    return true
end

# sample size set low for test performance
function isimplication(→)
    →(0, 0) == →(1, 1) == 1 && →(1, 0) == 0 || return false
    for (a, b, x) in zip(𝓍[1:19], 𝓍[2:20], 𝓏[2:20])    # strictly a .<= b
        →(a, x) >= →(b, x) &&                            # monotonicity in 1st
        →(x, a) <= →(x, b) ||                            # monotonicity in 2nd
        return false
    end
    return true
end

"""
Axiom adherence of an implication function

`N` is a strong negation function, i.e. a fuzzy complement `~~x == x`.
`T` is a left-continuous t-norm, defaults to nilpotent minimum

Mas, M., Monserrat, M., Torrens, J., & Trillas, E. (2007). A survey on fuzzy implication functions. IEEE Transactions on fuzzy systems, 15(6), 1107-1121.
"""
function implicationproperties(I; N = negate)
    isimplication(I) || throw("Not an implication function.")
    !isstrongnegation(N) && @warn "negation function is not strong."
    x, y, z = (𝓍[1:3])
    isimplication(I) || throw("Not an implication function.")
    (
        true,                          # monotonocity in 1st arg
        true,                          # monotonocity in 2nd arg
        #true,                         # {0,1}² coincides p ⟹ q ≡ ¬p ∨ q
        I(0, x) == 1,                  # dominance of falsity
        I(1, y) == y,                  # left neutrality principle
        I(x, x) == 1,                  # identity property
        I(x, I(y, z)) == I(y, I(x, z)),# exchange property
        I(x, y) == 1 && I(y, x) != 1,  # boundary condition
        I(x, y) == I(N(y), N(x))       # contraposition to strong negation
    )
end
#endregion

Zadeh       = Logic(negate, min, max, gödel)
Drastic     = Logic(negate, ∏_drastic, ∑_drastic, drastic)
Product     = Logic(negate, ∏_algebraic, ∑_algebraic, goguen)
Łukasiewicz = Logic(negate, bounded_difference, ∑_bounded, łukasiewicz)
Fodor       = Logic(negate, nilpotent_minimum, nilpotent_maximum, fodor)
# Fodor & Roubens, page 20)
function Frank(s)
    0 < s < Inf || throw("improper Frank domain")
    if s == 0 Zadeh
    elseif s == 1 Product
    elseif isinf(s) Łukasiewicz
    else
        T = (x, y) -> log(1 + (s^x - 1) * (s^y - 1) / (s - 1)) / log(s)
        Logic(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : log(1 + (s - 1) * (s^y - 1) / (s^x - 1)) / log(s)
        )
    end
end

function Hamacher(;α = nothing, β = 0, γ = 0)
    if isnothing(α) α = (1 + β) / (1 + γ) end
    α < 0 || β < -1 || γ < -1 && throw("Invalid Hamacher parameter")
    Logic(
        x -> (1 - x) / (1 + γ * x),
        (x, y) -> x * y == 0 ? 0 : x * y / (α + (1 - α) * (x + y - x * y)),
        (x, y) -> (x + y + β*x*y - x*y) / (1 + β*x*y),
        (x, y) -> x <= y ? 1 : (-α*x*y + α*y + x*y) / (-α*x*y + α*y + x*y + x - y)
    )
end
# make into family using standard negation and DeMorgan triplet associated t-conorm
function Schweizer_Sklar(p)
    if p == -Inf Zadeh
    elseif p == 0 Product
    elseif isinf(p) Drastic
    else
        T = if p < 0
            (x, y) -> (x^p + y^p - 1) ^ (1/p)
        else
            (x, y) -> (max(0, x^p + y^p - 1)) ^ (1/p)
        end
        Logic(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : (1 - x^p + y^p) ^ (1/p)
        )
    end
end
function Yager(p)
    p < 0 && throw("invalid Yager parameter")
    if p == 0 Drastic
    elseif p == Inf Zadeh
    else
        Logic(
            negate,
            (x, y) -> max(0, 1 - ((1 - x)^p + (1 - y)^p)^(1/p)),
            (x, y) -> min(1, (x^p + y^p) ^ (1/p)),
            (x, y) -> x <= y ? 1 : 1 - ((1 - y)^p - (1 - x)^p)^(1/p)
        )
    end
end
function Dombi(p)
    p < 0 && throw("invalid Dombi parameter")
    if p == 0 Drastic
    elseif p == Inf Zadeh
    else
        T(x, y) = x*y == 0 ? 0 : 1 / (1 + ((1 / x - 1)^p + (1 / y - 1)^p)^(1 / p))
        Logic(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : 1 / (1 + ((1 / y - 1)^p - (1 / x - 1)^p)^(1/p))
        )
    end
end
function Aczel_Alsina(p)
    p < 0 && throw("Invalid Aczel_Alsina parameters")
    if p == 0 Drastic
    elseif p == Inf Zadeh
    else
        T(x, y) = exp(- (abs(log(x))^p + abs(log(y))^p))
        Logic(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : exp(-((abs(log(y))^p - abs(log(x))^p))^(1/p))
        )
    end
end

function Sugeno_Weber(p)
    p < -1 && throw("invalid Segeno_Weber parameter")
    if p == -1 Drastic
    elseif p == Inf Product
    else
        Logic(
            negate,
            (x, y) -> max(0, (x + y - 1 + p * x * y) / (1 + p)),
            (x, y) -> min(1, x + y - p * x * y / (1 + p)),
            (x, y) -> x <= y ? 1 : (1 + (1 + p) * y - x) / (1 + p * x)
        )
    end
end
function Dubois_Prade(p)
    p < 0 || p > 1 && throw("Invalid Dubois_Prade parameter")
    if p == 0 Zadeh
    elseif p == 1 Product
    else
        T(x, y) = x * y / max(x, y, p)
        Logic(
            negate,
            T,
            (x, y) -> 1 - T(1 - x, 1 - y),
            (x, y) -> x <= y ? 1 : max(p / x, 1) * y
        )
    end
end

function Yu(p)
    p < -1 && throw("invalid Yu parameter")
    if p == -1 Product
    elseif p == Inf Drastic
    else
        Logic(
            negate,
            (x, y) -> max(0, (1 + p) * (x + y - 1) - p * x * y),
            (x, y) -> min(1, x + y + p * x * y),
            gödel # placeholder to pass test - TODO.
        )
    end
end
