# implication (residua) compute the fulfillment degree of a rule expressed by IF X THEN Y.

# antecedent
# consequent

# T, S, C are t-norm, s-norm, t-conorm operators
#=
Family      Method                          Relations
S           S(C(x), b)                      largest >= Łukasiewicz >= Reichenbach >= Kleene-Dienes
R           sup{i∈[0,1] | T(x, i) <= y}     largest >= Łukasiewicz >= Goguen >= Gödel
QL          S(C(x), T(x, y))
T-power     sup{r ∈ [0,1] | Yₜʳ ≥ x} ∀ x,y ∈ [0,1]
=#


# Implication                                                           # Families        Complement
I_Kleene_Dienes(x, y)  = max(1 - x, y)                                  # S D QL          1 - x
I_Łukasiewicz(x, y)    = min(1, 1 - x + y)                              # S R D QL        1 - x
I_Reichenbach(x, y)    = 1 - x + x * y                                  # S D QL          1 - x
I_largest_S(x, y)      = y == 0 ? 1 - x : x == 1 ? y : 1                # S
I_largest_R(x, y)      = x == 1 ? y : 1                                 # R
I_Zadeh(x, y)          = max(1 - x, min(x, y))                          # QL              1 - x Wilmott
I_Weber(x, y)          = x < 1 ? 1 : x == 1 ? y : nothing               # 
I_Dubois_Prade(x, y)   = y == 0 ? 1 - x : x == 1 ? y : 1                # 
I_Zadeh_late(x, y)     = x < 0.5 || 1 - x > y ? 1 - x : x < y ? x : y   # 

I_Gödel(x, y)          = x <= y ? 1 : y                                 # R
I_Goguen(x, y)         = min(1, y / x) # x <= y ? 1 : y / x             # R
I_Gaines_Rescher(x, y) = x <= y ? 1 : 0                                 # 
I_Sharp(x, y)          = x <= y ? 1 : 0                                 # 
I_Fodor(x, y)          = x <= y ? 1 : max(1 - x, y)                     # 
I_Wu(x, y)             = x <= y ? 1 : min(1 - x, y)                     # 
I_Yager(x, y)          = x == y == 0 ? 1 : y^x                          # 
I_YagerS(x, y, p)      = min(((1 - x)^p + y^p)^(1/p), 1)                # S
I_YagerR(x, y, p)      = x <= y ? 1 : 1 - ((1 - y)^p - (1 - x)^p)^(1/p) # R
I_Mamdani(x, y)        = min(x, y)                                      # 
I_Larsen(x, y)         = x * y                                          # 
I_Force(x, y)          = (1 - abs(x - y))x                              # 
I_Drastic(x, y)        = x == 1 && y == 0 ? 0 : 1

function isimplication(fun)
    x, y, z = sort(rand(3))
    fun(x, z) >= fun(y, z) &&                               # I1 ∀z ∈ [0,1]
        fun(x, y) <= fun(x, z) &&                           # I2 ∀x ∈ [0,1] 
        fun(0, 0) == fun(1, 1) == 1 && fun(1, 0) == 0       # I3
end

"""
Axiom adherence of an implication function

`N` is a strong negation function, i.e. a fuzzy complement `~~x == x`.  
`T` is a left-continuous t-norm, defaults to nilpotent minimum

Mas, M., Monserrat, M., Torrens, J., & Trillas, E. (2007). A survey on fuzzy implication functions. IEEE Transactions on fuzzy systems, 15(6), 1107-1121.
"""
function implicationproperties(I; negation = x -> 1 - x, tnorm = (x, y) -> x + y > 1 ? min(x, y) : 0)
    x, y, z = sort(rand(4))
    !isstrongnegation(negation) && @warn "negation function is not strong. Property requirements 8, 10, 12"
    N, T = negation, tnorm
    (
        M₁ = I(x, y) >= I(y, z),                    # monotonocity in 1st arg           I1
        M₂ = I(x, y) <= I(x, z),                    # monotonocity in 2nd arg           I2
        CC = I(0, 0) == I(1, 1) == I(1, 0) + 1 == 1,# {0,1}² coincides p ⟹ q ≡ ¬p ∨ q  I3
        DF = I(0, x) == 1,                          # dominance of falsity              I4
        NP = I(1, x) == x,                          # left neutrality principle         I5
        ID = I(x, x) == 1,                          # identity property                 I6
        EP = I(x, I(y, z)) == I(y, I(x, z)),        # exchange property                 I7
        CPN = I(x, y) == I(N(y), N(x)),             # contraposition to strong negation I8
        OP = I(x, y) == 1 && I(y, x) != 1,          # ordering property                 I9
        SN = isstrongnegation(x -> I(x, 0)),        # strong negation                   I10
        MP = T(x, I(x, y)) <= y,                    # modus ponens                      I11
        unknown = I(x, N(x)) == N(x),               # --                                I12
        BC = I(x, y) == 1 && I(y, x) != 1           # boundary condition                I13
        # add: distributivity properties, laws of importation
    )
end
# reductivity, continuity and approximation properties.

# https://arxiv.org/pdf/2002.06100.pdf
# b0 controls the position of the sigmoidal curve and s controls the ‘spread’ of the curve.
# I is an implication function
function sigmoidal(I, x, y, s, b₀)
    @assert s > 0 
    σ(x) = 1 / (1 + exp(x))
    if b₀ ≡ -0.5
        (1 / (exp(.5s) - 1)) * ((1 + exp(.5s)) * σ(s * (I(x, y) - .5)) - 1)
    else
        eₛᵦ = exp(-s * (1 + b₀))
        eᵦₛ = exp(-b₀ * s)
        ((1 + eₛᵦ) / (eᵦₛ - eₛᵦ)) * ((1 + eᵦₛ) * σ(s*(I(x, y) + b₀)) - 1)
    end
end