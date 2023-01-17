# Implication (residua) compute the fulfillment degree of a rule expressed by IF X THEN Y.

kleene_dienes(x, y)  = max(1 - x, y)
łukasiewicz(x, y)    = min(one(x), 1 - x + y)
mizumoto = reichenbach(x, y) = 1 - x + x * y
largest_S = dubois_prade(x, y) = y == zero(x) ? 1 - x : x == 1 ? y : one(x)
largest_R(x, y)      = x == 1 ? y : one(x)
zadeh(x, y)          = max(1 - x, min(x, y))
weber(x, y)          = x < 1 ? one(x) : x == 1 ? y : zero(x)
zadeh_late(x, y)     = x < 0.5 || 1 - x > y ? 1 - x : x < y ? x : y
gödel(x, y)          = x <= y ? one(x) : y
goguen(x, y)         = x <= y ? one(x) : y / x
sharp = gaines_rescher(x, y) = x <= y ? one(x) : zero(x)
fodor(x, y)          = x <= y ? one(x) : max(1 - x, y)
wu(x, y)             = x <= y ? one(x) : min(1 - x, y)
yager(x, y)          = x == y == 0 ? one(x) : y^x
drastic(x, y)        = x == 1 && y == 0 ? zero(x) : one(x)

# yagerS(x, y, p)      = min(((1 - x)^p + y^p)^(1/p), 1)
# yagerR(x, y, p)      = x <= y ? 1 : 1 - ((1 - y)^p - (1 - x)^p)^(1/p)

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
