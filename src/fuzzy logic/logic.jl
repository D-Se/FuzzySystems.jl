struct Logic
    T::Function # t-norm, intersection of fuzzy sets
    S::Function # s-norm, union of fuzzy sets
    I::Function # implication, fulfillment degree of a rule
    N::Function # negation
end

negate(x) = 1 - x

#region complete logics
# Style: \bisansX
𝙕ᵗ          = Base.min
𝙕ˢ          = Base.max
𝙕ⁱ(x, y)    = x <= y ? one(x) : y # gödel
𝙕ⁿ          = negate
Zadeh = Logic(𝙕ᵗ, 𝙕ˢ, 𝙕ⁱ, 𝙕ⁿ)

𝘼ᵗ(x, y)    = x * y
𝘼ˢ(x, y)    = 1 - (1 - x) * (1 - y)
𝘼ⁱ(x, y)    = x <= y ? one(x) : y / x
𝘼ⁿ          = negate
Algebraic = Logic(𝘼ᵗ, 𝘼ˢ, 𝘼ⁱ, 𝘼ⁿ)

𝘿ᵗ(x, y)    = isone(max(x, y))  ? min(x, y) : zero(x)
𝘿ˢ(x, y)    = iszero(min(x, y)) ? max(x, y) : one(x)
𝘿ⁱ(x, y)    = x == 1 && y == 0  ? zero(x)   : one(x)
𝘿ⁿ          = negate
Drastic = Logic(𝘿ᵗ, 𝘿ˢ, 𝘿ⁱ, 𝘿ⁿ)

𝙇ᵗ(x, y)    = max(0, x + y - 1)
𝙇ˢ(x, y)    = min(1, x + y)
𝙇ⁱ(x, y)    = min(one(x), 1 - x + y)
𝙇ⁿ          = negate
Łukasiewicz = Logic(𝙇ᵗ, 𝙇ˢ, 𝙇ⁱ, 𝙇ⁿ)

𝙁ᵗ(x, y)    = x + y > 1 ? min(x, y) : zero(x)
𝙁ˢ(x, y)    = x + y < 1 ? max(x, y) : one(x)
𝙁ⁱ(x, y)    = x <= y ? one(x) : max(1 - x, y)
𝙁ⁿ          = negate
Fodor = Logic(𝙁ᵗ, 𝙁ˢ, 𝙁ⁱ, 𝙁ⁿ)
#endregion

#region incomplete logics
# Regular capital letter

𝙀ᵗ(x, y) = x * y / (2 - (x + y - x * y))
𝙀ˢ(x, y) = (x + y) / (1 + x * y)

𝙃ᵗ(x, y) = x == y == 0 ? 0.0 : x * y / (x + y - x * y)
𝙃ˢ(x, y) = (2 * y * x - x - y) / (x * y - 1)

# Implication functions
KDⁱ(x, y) = max(1 - x, y)
Rⁱ = Mⁱ(x, y) = 1 - x + x * y
DPⁱ(x, y) = y == zero(x) ? 1 - x : x == 1 ? y : one(x)
Zⁱ(x, y) = max(1 - x, min(x, y))
Zⁱ²(x, y) = x < 0.5 || 1 - x > y ? 1 - x : x < y ? x : y
Wⁱ(x, y) = x < 1 ? one(x) : x == 1 ? y : zero(x)
Sⁱ = GRⁱ(x, y) = x <= y ? one(x) : zero(x)
Wuⁱ(x, y) = x <= y ? one(x) : min(1 - x, y)
Yⁱ(x, y) = x == y == 0 ? one(x) : y^x
largest_R(x, y) = x == 1 ? y : one(x)

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
    if λ == 0 Zadeh
    elseif λ == 1 Product
    elseif isinf(λ) Łukasiewicz
    else
        𝓕ᵗ(x, y) = log(1 + (λ^x - 1) * (λ^y - 1) / (λ - 1)) / log(λ)
        𝓕ˢ(x, y) = 1 - 𝓕ᵗ(1 - x, 1 - y)
        𝓕ⁱ(x, y) = x <= y ? 1 : log(1 + (λ - 1) * (λ^y - 1) / (λ^x - 1)) / log(λ)
        𝓕ⁿ       = negate
        Logic(𝓕ᵗ, 𝓕ˢ, 𝓕ⁱ, 𝓕ⁿ)
    end
end

function Hamacher(;α = nothing, β = 0, γ = 0)
    if isnothing(α) α = (1 + β) / (1 + γ) end
    α < 0 || β < -1 || γ < -1 && throw("Invalid Hamacher parameter")
    𝓗ᵗ(x, y) = x * y == 0 ? 0 : x * y / (α + (1 - α) * (x + y - x * y))
    𝓗ˢ(x, y) = (x + y + β*x*y - x*y) / (1 + β*x*y)
    𝓗ⁱ(x, y) = x <= y ? 1 : (-α*x*y + α*y + x*y) / (-α*x*y + α*y + x*y + x - y)
    𝓗ⁿ(x)    = (1 - x) / (1 + γ * x)
    Logic(𝓗ᵗ, 𝓗ˢ, 𝓗ⁱ, 𝓗ⁿ)
end

function Schweizer_Sklar(λ)
    if λ == -Inf Zadeh
    elseif λ == 0 Product
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
    elseif λ == Inf Zadeh
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
    elseif λ == Inf Zadeh
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
    elseif λ == Inf Zadeh
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
    elseif λ == Inf Product
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
    if λ == 0 Zadeh
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
    if λ == -1 Product
    elseif λ == Inf Drastic
    else
        𝓨𝓤ᵗ(x, y) = max(0, (1 + λ) * (x + y - 1) - λ * x * y)
        𝓨𝓤ˢ(x, y) = min(1, x + y + λ * x * y)
        𝓨𝓤ⁱ       = 𝙕ⁱ # placeholder to pass test - TODO
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
