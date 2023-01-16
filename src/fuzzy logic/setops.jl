
#region T-norm: intersection of fuzzy sets (OR, |). Triangular-norm.

# min(x...)                 = Base.min(x...) # Gödel
∏_algebraic(x, y)           = x * y	# product t-norm (Fodor, 2016)
bounded_difference(x, y)    = max(0, x + y - 1) # Łukasiewicz, bold intersection
∏_drastic(x, y)             = isone(max(x, y)) ? min(x, y) : zero(x) # Dubois 1979
∏_einstein(x, y)            = x * y / (2 - (x + y - x * y))
∏_hamacher(x, y)            = x == y == 0 ? 0.0 : x * y / (x + y - x * y)
nilpotent_minimum(x, y)     = x + y > 1 ? min(x, y) : zero(x)

# minimum(vec)              =  Base.minimum(vec)
∏_algebraic(vec)            = prod(vec) # strict nilpotent
bounded_difference(vec)     = reduce(bounded_difference, vec)
∏_drastic(vec)          	= isone(maximum(vec)) ? minimum(vec) : 0.0
∏_einstein(vec)             = reduce(einstein_product, vec)
∏_hamacher(vec)             = reduce(hamacher_product, vec)
nilpotent_minimum(vec)      = reduce(nilpotent_minimum, vec)
#endregion

#region S-norm: union of fuzzy sets (AND, &). Synonym of t-conorm

# max(x...)                 = Base.max(x...)
∑_algebraic(x, y)           = (1 - x)y + x # Łukasiewicz s-norm
∑_bounded(x, y)             = min(1, x + y)
∑_drastic(x, y)             = iszero(min(x, y)) ? max(x, y) : one(x) # Dubois
∑_einstein(x, y)            = (x + y) / (1 + x * y)
∑_hamacher(x, y)            = (2y * x - x - y) / (x * y - 1)
nilpotent_maximum(x, y)     = x + y < 1 ? max(x, y) : one(x) # Fodor
∑_probabilistic(x, y)       = x + y - x * y

# maximum(vec)              = Base.maximum(vec)
∑_algebraic(vec)            = reduce(algebraic_sum, vec)
∑_bounded(vec)              = reduce(bounded_sum, vec)
∑_drastic(vec)              = reduce(drastic_sum, vec)
∑_einstein(vec)             = @fastmath reduce(einstein_sum, vec)
∑_hamacher(vec)             = @fastmath reduce(hamacher_sum, vec)

#endregion

const OP_ALIAS = Dict(
    # T-norms
    :min => minimum, :MIN => minimum, :Gödel => minimum, :minimum => minimum,
    :∏_algebraic => ∏_algebraic, :algebraic_product => ∏_algebraic, :prod => ∏_algebraic,
    :bounded_difference => bounded_difference,
    :∏_drastic => ∏_drastic, :drastic_product => ∏_drastic,
    :∏_einstein => ∏_einstein, :einstein_product => ∏_einstein,
    :∏_hamacher => ∏_hamacher, :hamacher_product => ∏_hamacher,
    :nilpotent_minimum => nilpotent_minimum, :nilmin => nilpotent_minimum,

    # S-norms
    :maximum => maximum, :max => maximum, :MAX => maximum,
    :algebraic_sum => ∑_algebraic, :∑_algebraic => ∑_algebraic,
    :bounded_sum => ∑_bounded, :∑_bounded => ∑_bounded,
    :drastic_sum => ∑_drastic, :∑_drastic => ∑_drastic,
    :einstein_sum => ∑_einstein, :∑_einstein => ∑_einstein,
    :hamacher_sum => ∑_hamacher, :∑_hamacher => ∑_hamacher,
    :nilmax => nilpotent_maximum, :nilpotent_maximum => nilpotent_maximum,
    :prob => ∑_probabilistic, :∑_probabilistic => ∑_probabilistic
)

#region Negations: complement of fuzzy set (NOT, !)

negate(x)                   = one(x) - x
#= negate_threshold(x, λ)      = x <= λ ? one(x) : zero(x)
negate_cosine(x)            = 0.5(1 + cos(x * π))
negate_sugeno(x, λ)         = λ > -1 ? 1 - x / (1 + λ * x) : nothing
negate_yager(x, λ)          = (1 - x^λ)^(1 / λ)
negate_intuitionistic(x)    = x == 0 ? one(x) : zero(x) =#

#endregion
