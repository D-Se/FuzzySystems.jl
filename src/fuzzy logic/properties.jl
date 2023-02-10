# Discovery & vetting tools

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
        #⊥(x, y) ≈ ~(⊤(~(x), ~(y))) || return false
        ~(⊤(x, y)) ≈ ⊥(~(x), ~(y)) && ~(⊥(x, y)) ≈ ⊤(~(x), ~(y)) || return false
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

issubset(𝒰, f₁::AbstractMember, f₂::AbstractMember) = μ.(𝒰, f₁) .<= μ(𝒰, f₂)

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
