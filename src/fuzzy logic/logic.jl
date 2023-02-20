struct Logic
    T::Function       # intersection of fuzzy sets
    S::Function       # union of fuzzy sets
    I::Union{Nothing, Function} # fulfillment degree of a rule
    N::Function # negation
end
Logic(T::Function, S::Function, I::Function) = Logic(T, S, I, negate)
Logic(T::Function, S::Function) = Logic(T, S, nothing, negate)

macro logic(type, defs)
    tobin(expr) = Expr(:->, Expr(:tuple, :x, :y), expr) |> eval
    Base.remove_linenums!(defs)
    len = length(⋆defs)
    lgl = if len == 3
        Logic(tobin(defs ⋆ 1), tobin(defs ⋆ 2), tobin(defs ⋆ 3))
    elseif len == 2
        Logic(tobin(defs ⋆ 1),  tobin(defs ⋆ 2))
    end
    for i in eachindex(⋆defs)
        defs.args[i] = postwalk(d -> d == :x ? :(x.ϕ) : d == :y ? :(y.ϕ) : d, defs ⋆ i)
    end
    @eval begin
        struct $type <: AbstractIsh
            ϕ::Float64
            #@noinline $type(ϕ) = new(AbstractIsh(ϕ)) # inherit from unit interval constructor
            $type(ϕ) = new(AbstractIsh(ϕ)) # inherit from unit interval constructor
        end
        @fastmath @inline begin # ϕ need not be IEEE-compliant
            (|)(x::$type, y::$type)::$type = $(defs ⋆ 1)      # t-norm
            (&)(x::$type, y::$type)::$type = $(defs ⋆ 2)      # s-norm
        end
    end
    len > 2 && @eval (⟹)(x::$type, y::$type)::$type = $(defs ⋆ 3) # implication
    len > 3 && @eval (!)(x::$type)::$type = $(defs ⋆ 4)
    return lgl
end

negate(x) = 1 - x

#region complete logics
# Style: \bisansX

Gödel_Dumett = @logic 𝙂ish begin
    min(x, y)
    max(x, y)
    x <= y ? 1 : y
end

Algebraic = @logic 𝘼ish begin
    x * y
    1 - (1 - x) * (1 - y)
    x <= y ? 1 : y / x
end

Drastic = @logic 𝘿ish begin
    max(x, y) == 1 ? min(x, y) : 0
    min(x, y) == 0 ? max(x, y) : 1
    x == 1 && y == 0  ? 0      : 1
end

Łukasiewicz = @logic 𝙇ish begin
    max(0, x + y - 1)
    min(1, x + y)
    min(1, 1 - x + y)
end

Fodor = @logic 𝙁ish begin
    x + y > 1 ? min(x, y) : 0
    x + y < 1 ? max(x, y) : 1
    x <= y    ? 1         : max(1 - x, y)
end

#region incomplete logics

Einstein = @logic 𝙀ish begin # intuitionistic
    x * y / (2 - (x + y - x * y))
    (x + y) / (1 + x * y)
end

Hamacher = @logic 𝙃ish begin
    x == y == 0 ? 0 : x * y / (x + y - x * y)
    (2 * y * x - x - y) / (x * y - 1)
end
#endregion

let
    struct store value::Union{𝙂ish, 𝘿ish, 𝘼ish, 𝙇ish, 𝙁ish, 𝙀ish, 𝙃ish} end
    global function ish(x)
        n = 𝓣.δ
        x = begin
            n == 1 ? 𝙂ish(x) |> store :
            n == 2 ? 𝘿ish(x) |> store :
            n == 3 ? 𝘼ish(x) |> store :
            n == 4 ? 𝙇ish(x) |> store :
            n == 5 ? 𝙁ish(x) |> store :
            n == 6 ? 𝙀ish(x) |> store :
            𝙃ish(x) |> store
        end
        return x.value
    end
end
ish(x::Missing) = missing

let
    type_constants = @aliasdict {
        1 G Gödel gödel Gödel_Dumett Dumett dumett
        2 D Drastic drastic
        3 P A Product Product Algebraic algebraic
        4 L Łukasiewicz Lukasiewicz lukasiewicz
        5 F Fodor fodor
        6 E Einstein einstein
        7 H Hamacher hamacher
    }

    global function setlogic!(name::Symbol)
        n = type_constants[name]
        global 𝓣.δ = n
    end
end

#endregion

# Implication functions
KDⁱ(x, y) = max(1 - x, y)
Rⁱ        = Mⁱ(x, y) = 1 - x + x * y
DPⁱ(x, y) = y == 0 ? 1 - x : x == 1 ? y : 1
Zⁱ(x, y)  = max(1 - x, min(x, y))
Zⁱ²(x, y) = x < 0.5 || 1 - x > y ? 1 - x : x < y ? x : y
Wⁱ(x, y)  = x < 1 ? 1 : x == 1 ? y : 0
Sⁱ = GRⁱ(x, y) = x <= y ? 1 : 0
Wuⁱ(x, y) = x <= y ? 1 : min(1 - x, y)
Yⁱ(x, y)  = x == y == 0 ? 1 : y^x
largest_R(x, y) = x == 1 ? y : 1

# https://arxiv.org/pdf/2002.06100.pdf
# b0 controls the position of the sigmoidal curve and s controls the ‘spread’ of the curve.

function sigmoidal(→, x, y, s, b₀)
    @assert s > 0
    σ(x) = 1 / (1 + exp(x))
    if b₀ ≡ -0.5
        (1 / (exp(.5s) - 1)) * ((1 + exp(.5s)) * σ(s * (→(x, y) - .5)) - 1)
    else
        eₛᵦ = exp(-s * (1 + b₀))
        eᵦₛ = exp(-b₀ * s)
        ((1 + eₛᵦ) / (eᵦₛ - eₛᵦ)) * ((1 + eᵦₛ) * σ(s*(→(x, y) + b₀)) - 1)
    end
end

#endregion

#region Parametric logics
# Style: \bscrX

function Frank(λ)
    0 < λ < Inf || throw("improper Frank domain")
    if λ == 0 Gödel_Dumett
    elseif λ == 1 Algebraic
    elseif isinf(λ) Łukasiewicz
    else
        𝓕ᵗ(x, y) = log(1 + (λ^x - 1) * (λ^y - 1) / (λ - 1)) / log(λ)
        𝓕ˢ(x, y) = 1 - 𝓕ᵗ(1 - x, 1 - y)
        𝓕ⁱ(x, y) = x <= y ? 1 : log(1 + (λ - 1) * (λ^y - 1) / (λ^x - 1)) / log(λ)
        𝓕ⁿ       = negate
        Logic(𝓕ᵗ, 𝓕ˢ, 𝓕ⁱ, 𝓕ⁿ)
    end
end

function Hamacher2(;α = nothing, β = 0, γ = 0)
    if isnothing(α) α = (1 + β) / (1 + γ) end
    α < 0 || β < -1 || γ < -1 && throw("Invalid Hamacher parameter")
    𝓗ᵗ(x, y) = x * y == 0 ? 0 : x * y / (α + (1 - α) * (x + y - x * y))
    𝓗ˢ(x, y) = (x + y + β*x*y - x*y) / (1 + β*x*y)
    𝓗ⁱ(x, y) = x <= y ? 1 : (-α*x*y + α*y + x*y) / (-α*x*y + α*y + x*y + x - y)
    𝓗ⁿ(x)    = (1 - x) / (1 + γ * x)
    Logic(𝓗ᵗ, 𝓗ˢ, 𝓗ⁱ, 𝓗ⁿ)
end

function Schweizer_Sklar(λ)
    if λ == -Inf Gödel_Dumett
    elseif λ == 0 Alegebraic
    elseif isinf(λ) Drastic
    else
        𝓢𝓢ᵗ = if isone(λ)
            𝙇ᵗ
        elseif λ == -1
            (x, y) -> (x * y) / (x + y - x * y)
        else
            (x, y) -> (max(0, x^λ + y^λ - 1)) ^ (1 / λ)
        end
        𝓢𝓢ˢ(x, y) = 1 - 𝓢𝓢ᵗ(1 - x, 1 - y)
        𝓢𝓢ⁱ(x, y) = x <= y ? 1 : (1 - x^λ + y^λ) ^ (1 / λ)
        𝓢𝓢ⁿ       = negate
        Logic(𝓢𝓢ᵗ, 𝓢𝓢ˢ, 𝓢𝓢ⁱ, 𝓢𝓢ⁿ)
    end
end

function Yager(λ)
    λ < 0 && throw("invalid Yager lambda")
    if λ == 0 Drastic
    elseif λ == Inf Gödel_Dumett
    else
        𝓨ᵗ(x, y) = max(0, 1 - ((1 - x)^λ + (1 - y)^λ)^(1/λ))
        𝓨ˢ(x, y) = λ == 1 ? 𝙇ˢ(x, y) : min(1, (x^λ + y^λ) ^ (1 / λ))
        𝓨ⁱ(x, y) =  x <= y ? 1 : 1 - ((1 - y)^λ - (1 - x)^λ)^(1 / λ)
        𝓨ⁿ       = negate
        Logic(𝓨ᵗ, 𝓨ˢ, 𝓨ⁱ, 𝓨ⁿ)
    end
end

function Dombi(λ)
    λ < 0 && throw("invalid Dombi parameter")
    if λ == 0 Drastic
    elseif λ == Inf Gödel_Dumett
    else
        𝓓ᵗ(x, y) = x*y == 0 ? 0 : 1 / (1 + ((1 / x - 1)^λ + (1 / y - 1)^λ)^(1 / λ))
        𝓓ˢ(x, y) = 1 - 𝓓ᵗ(1 - x, 1 - y)
        𝓓ⁱ(x, y) = x <= y ? 1 : 1 / (1 + ((1 / y - 1)^λ - (1 / x - 1)^λ)^(1 / λ))
        𝓓ⁿ       = negate
        Logic(𝓓ᵗ, 𝓓ˢ, 𝓓ⁱ, 𝓓ⁿ)
    end
end

function Aczel_Alsina(λ)
    λ < 0 && throw("Invalid Aczel_Alsina parameters")
    if λ == 0 Drastic
    elseif λ == Inf Gödel_Dumett
    else
        𝓐𝓐ᵗ(x, y) = exp(- (abs(log(x))^λ + abs(log(y))^λ))
        𝓐𝓐ˢ(x, y) = 1 - 𝓐𝓐ᵗ(1 - x, 1 - y)
        𝓐𝓐ⁱ(x, y) = x <= y ? 1 : exp(-((abs(log(y))^λ - abs(log(x))^λ))^(1 / λ))
        𝓐𝓐ⁿ       = negate
        Logic(𝓐𝓐ᵗ, 𝓐𝓐ˢ, 𝓐𝓐ⁱ, 𝓐𝓐ⁿ)
    end
end

function Sugeno_Weber(λ)
    λ < -1 && throw("invalid Segeno_Weber parameter")
    if λ == -1 Drastic
    elseif λ == Inf Algebraic
    else
        𝓢𝓦ᵗ(x, y) = max(0, (x + y - 1 + λ * x * y) / (1 + λ))
        𝓢𝓦ˢ(x, y) = min(1, x + y - λ * x * y / (1 + λ))
        𝓢𝓦ⁱ(x, y) = x <= y ? 1 : (1 + (1 + λ) * y - x) / (1 + λ * x)
        𝓢𝓦ⁿ       = negate
        Logic(𝓢𝓦ᵗ, 𝓢𝓦ˢ, 𝓢𝓦ⁱ, 𝓢𝓦ⁿ)
    end
end

function Dubois_Prade(λ)
    λ < 0 || λ > 1 && throw("Invalid Dubois_Prade parameter")
    if λ == 0 Gödel_Dumett
    elseif λ == 1 Product
    else
        𝓓𝓟ᵗ(x, y) = x * y / max(x, y, λ)
        𝓓𝓟ˢ(x, y) = 1 - 𝓓𝓟ᵗ(1 - x, 1 - y)
        𝓓𝓟ⁱ(x, y) = x <= y ? 1 : max(λ / x, 1) * y
        𝓓𝓟ⁿ       = negate
        Logic(𝓓𝓟ᵗ, 𝓓𝓟ˢ, 𝓓𝓟ⁱ, 𝓓𝓟ⁿ)
    end
end

function Yu(λ)
    λ < -1 && throw("invalid Yu parameter")
    if λ == -1 Algebraic
    elseif λ == Inf Drastic
    else
        𝓨𝓤ᵗ(x, y) = max(0, (1 + λ) * (x + y - 1) - λ * x * y)
        𝓨𝓤ˢ(x, y) = min(1, x + y + λ * x * y)
        𝓨𝓤ⁱ       = Gödel_Dumett.I # placeholder to pass test - TODO
        𝓨𝓤ⁿ       = negate
        Logic(𝓨𝓤ᵗ, 𝓨𝓤ˢ, 𝓨𝓤ⁱ, 𝓨𝓤ⁿ)
    end
end


#=
Included in source for completeness
negate_threshold(x, λ)      = x <= λ ? one(x) : zero(x)
negate_cosine(x)            = 0.5(1 + cos(x * π))
negate_sugeno(x, λ)         = λ > -1 ? 1 - x / (1 + λ * x) : nothing
negate_yager(x, λ)          = (1 - x^λ)^(1 / λ)
negate_intuitionistic(x)    = x == 0 ? one(x) : zero(x)
=#
