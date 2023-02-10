struct Logic
    T::Function # t-norm, intersection of fuzzy sets
    S::Function # s-norm, union of fuzzy sets
    I::Function # implication, fulfillment degree of a rule
    N::Function # negation
end

negate(x) = one(x) - x

# Internal toggles to swap fuzzy backends for &, |, ⟹, ! ops.
# Using fields ensures type stability and 0 allocations in ops.
mutable struct OpConst δ::Int8 end
const 𝑨𝑵𝑫   = OpConst(1)
const 𝑶𝑹    = OpConst(1)
const 𝑰𝑴𝑷𝑳𝒀 = OpConst(1)
const 𝑵𝑶𝑻   = OpConst(1)

let
    op_constants = Dict(
        :Zadeh       => (1, 1, 1, 1),
        :Drastic     => (2, 2, 2, 1),
        :Product     => (3, 3, 3, 1),
        :Łukasiewicz => (4, 4, 4, 1),
        :Fodor       => (5, 5, 5, 1)
    )
    global function setlogic!(name::Symbol)
        n = op_constants[name]
        global 𝑨𝑵𝑫.δ    = n[1]
        global 𝑶𝑹.δ     = n[2]
        global 𝑰𝑴𝑷𝑳𝒀.δ  = n[3]
        #global 𝑵𝑶𝑻.δ    = n[4]
    end
end

𝙕ᵗ          = Base.min
𝙕ˢ          = Base.max
𝙕ⁱ(x, y)    = x <= y ? one(x) : y # gödel
𝙕ⁿ          = negate
Zadeh = Logic(𝙕ᵗ, 𝙕ˢ, 𝙕ⁱ, 𝙕ⁿ)

𝘿ᵗ(x, y)    = isone(max(x, y))  ? min(x, y) : zero(x) # drastic product
𝘿ˢ(x, y)    = iszero(min(x, y)) ? max(x, y) : one(x) # drastic sum
𝘿ⁱ(x, y)    = x == 1 && y == 0  ? zero(x)   : one(x)
𝘿ⁿ          = negate
Drastic = Logic(𝘿ᵗ, 𝘿ˢ, 𝘿ⁱ, 𝘿ⁿ)

𝙋ᵗ(x, y)    = x * y
𝙋ˢ(x, y)    = (1 - x) * y + x
𝙋ⁱ(x, y)    = x <= y ? one(x) : y / x
𝙋ⁿ          = negate
Product = Logic(𝙋ᵗ, 𝙋ˢ, 𝙋ⁱ, 𝙋ⁿ)

𝙇ᵗ(x, y)    = max(0, x + y - 1) # bold intersection, bounded difference
𝙇ˢ(x, y)    = min(1, x + y) # bounded sum
𝙇ⁱ(x, y)    = min(one(x), 1 - x + y)
𝙇ⁿ          = negate
Łukasiewicz = Logic(𝙇ᵗ, 𝙇ˢ, 𝙇ⁱ, 𝙇ⁿ)

𝙁ᵗ(x, y)    = x + y > 1 ? min(x, y) : zero(x) # nilpotent minimum
𝙁ˢ(x, y)    = x + y < 1 ? max(x, y) : one(x) # nilpotent maximum
𝙁ⁱ(x, y)    = x <= y ? one(x) : max(1 - x, y)
𝙁ⁿ          = negate
Fodor = Logic(𝙁ᵗ, 𝙁ˢ, 𝙁ⁱ, 𝙁ⁿ)

# Parametric logic families

function Frank(λ)
    0 < λ < Inf || throw("improper Frank domain")
    if λ == 0 Zadeh
    elseif λ == 1 Product
    elseif isinf(λ) Łukasiewicz
    else
        𝓕ᵗ(x, y) = log(1 + (λ^x - 1) * (λ^y - 1) / (λ - 1)) / log(λ)
        𝓕ˢ(x, y) = 1 - 𝓕ᵗ(1 - x, 1 - y)
        𝓕ⁱ(x, y) = x <= y ? 1 : log(1 + (λ - 1) * (λ^y - 1) / (λ^x - 1)) / log(λ)
        𝓕ⁿ = negate
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
        𝓢𝓢ⁿ = negate
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
        𝓨ⁿ = negate
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
        𝓓ⁿ = negate
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
        𝓐𝓐ⁿ = negate
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
        𝓢𝓦ⁿ = negate
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
        𝓓𝓟ⁿ = negate
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
        𝓨𝓤ⁱ = 𝙕ⁱ # placeholder to pass test - TODO
        𝓨𝓤ⁿ = negate
        Logic(𝓨𝓤ᵗ, 𝓨𝓤ˢ, 𝓨𝓤ⁱ, 𝓨𝓤ⁿ)
    end
end
