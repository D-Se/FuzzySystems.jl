# intersection (OR). triangular-norm.

"""
is a fuzzy intersection (OR) function of the form `[0,1]² -> [0,1]` 1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
function istnorm(fun)
	a, b, d = rand(3)
	if b > d b, d = d, b end
	fun(a, fun(b, d)) == fun(fun(a, b), d) && # associativity
		fun(a, b) <= fun(a, d) && # monotonicity
		fun(a, b) == fun(b, a) && # communicativity
		fun(a, 1) == a # boundary requirement 
	# continuity or strict monotonicty may be added
end

#= minimum_value(strengths) = minimum(strengths) # continuous, idempotent
algebraic_product(strengths) = prod(strengths) # strict nilpotent
bounded_difference(strengths) = reduce((x, i) -> max(0, x + i - 1), strengths)
drastic_product(strengths) 	= isone(maximum(strengths)) ? minimum(strengths) : 0.0
einstein_product(strengths) = reduce((x, i) -> x * i / (2 - (x + i - x * i)), strengths)
hamacher_product(strengths) = reduce((x, i) -> x * i / (x + i - x * i), strengths) =#

minimumT(x, y)				= min(x, y) # Gödel
algebraic_product(x, y)     = x * y	# product t-norm (Fodor, 2016)
bounded_difference(x, y)    = max(0, x + y - 1) # Łukasiewicz 
drastic_product(x, y)       = isone(max(x, y)) ? min(x, y) : 0 # Dubois 1979
einstein_product(x, y)      = x * y / (2 - (x + y - x * y))
hamacher_product(x, y)      = x == y == 0 ? 0 : x * y / (x + y - x * y)
T_Fodor(x, y)               = x + y > 1 ? min(x, y) : 0 # nilpotent minimum