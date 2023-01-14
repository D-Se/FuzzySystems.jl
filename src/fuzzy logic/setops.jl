
#region T-norm: intersection of fuzzy sets (OR, |). Triangular-norm.

# minimum(vec)         =  Base.minimum(vec)
algebraic_product(vec)      = prod(vec) # strict nilpotent
bounded_difference(vec)     = reduce(bounded_difference, vec)
drastic_product(vec)    	= isone(maximum(vec)) ? minimum(vec) : 0.0
einstein_product(vec)       = reduce(einstein_product, vec)
hamacher_product(vec)       = reduce(hamacher_product, vec)

# min(x...)                   = Base.min(x...) # Gödel
algebraic_product(x, y)     = x * y	# product t-norm (Fodor, 2016)
bounded_difference(x, y)    = max(0, x + y - 1) # Łukasiewicz
drastic_product(x, y)       = isone(max(x, y)) ? min(x, y) : 0 # Dubois 1979
einstein_product(x, y)      = x * y / (2 - (x + y - x * y))
hamacher_product(x, y)      = x == y == 0 ? 0 : x * y / (x + y - x * y)
nilpotent_minimum(x, y)     = x + y > 1 ? min(x, y) : 0
#endregion

#region S-norm: union of fuzzy sets (AND, &). Synonym of t-conorm

# maximum(vec)      = Base.maximum(vec)
algebraic_sum(vec) 	= reduce(algebraic_sum, vec)
bounded_sum(vec) 	= reduce(bounded_sum, vec)
drastic_sum(vec) 	= reduce(drastic_sum, vec)
einstein_sum(vec) 	= @fastmath reduce(einstein_sum, vec)
hamacher_sum(vec) 	= @fastmath reduce(hamacher_sum, vec)

# max(x...)                 = Base.max(x...)
algebraic_sum(x, y) 		= (1 - x)y + x #  Łukasiewicz t-conorm
bounded_sum(x, y) 			= min(1, x + y)
drastic_sum(x, y) 			= iszero(min(x, y)) ? max(x, y) : 1 # Dubois
einstein_sum(x, y) 			= x * y / (1 + x * y)
hamacher_sum(x, y) 			= (2y * x - x - y) / (x * y - 1)
nilpotent_maximum(x, y)	    = x + y < 1 ? max(x, y) : 0 # S_Fodor
probabilistic_sum(x, y)     = x + y - x * y
#endregion

const OP_ALIAS = Dict(
    # T-norms
    :min => minimum, :MIN => minimum, :Gödel => minimum, :minimum => minimum,
    :algebraic_product => algebraic_product, :prod => algebraic_product,
    :bounded_difference => bounded_difference,
    :drastic_product => drastic_product,
    :einstein_product => einstein_product,
    :hamacher_product => hamacher_product,
    :nilpotent_minimum => nilpotent_minimum, :nilmin => nilpotent_minimum,

    # S-norms
    :maximum => maximum, :max => maximum, :MAX => maximum,
    :algebraic_sum => algebraic_sum,
    :bounded_sum => bounded_sum,
    :drastic_sum => drastic_sum,
    :einstein_sum => einstein_sum,
    :hamacher_sum => hamacher_sum,
    :nilmax => nilpotent_maximum, :nilpotent_maximum => nilpotent_maximum,
    :prob => probabilistic_sum
)

#region Negations: complement of fuzzy set (NOT, !)

negate(x)                     = 1 - x
negate_threshold(x)           = x <= 0 ? 1 : 0
negate_cosine(x)              = 0.5(1 + cos(x*π))
negate_sugeno(x, λ)           = λ > -1 ? 1 - x / (1 + λ * x) : nothing
negate_yager(x, λ)            = (1 - x^λ)^(1 / λ)
negate_intuitionistic(x)      = x == 0 ? 1 : 0
negate_dual_intuitionistic(x) = x < 1 ? 1 : x == 1 ? 0 : nothing
#endregion
