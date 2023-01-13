# Union of fuzzy sets (AND). Synonym of t-conorm.

"""
is a fuzzy union (AND) of the form `[0,1]² -> [0,1]` 1) associative, 2) monotone, 3) communicative and 4) bounded?
"""
function issnorm(fun)
	a, b, d = rand(3)
	if b > d b, d = d, b end
	fun(a, fun(b, d)) == fun(fun(a, b), d) && # associativity
		fun(a, b) <= fun(a, d) && # monotonicity
		fun(a, b) == fun(b, a) && # communicativity
		fun(a, 0) == a # boundary requirement
	# t-conorm iff u(a, b) = 1 - t-norm(1 - a, 1 - b) [mutually dual]
end

#= maximum_value(strengths) = maximum(strengths)
algebraic_sum(strengths) 	= reduce((x, i) -> (1 - x)i + x, strengths)
bounded_sum(strengths) 		= reduce((x, i) -> min(1, x + i), strengths)
drastic_sum(strengths) 		= reduce((x, i) -> iszero(min(x, i)) ? max(x, i) : 1.0, strengths)
einstein_sum(strengths) 	= @fastmath reduce((x, i) -> x * i / (1.0 + x * i), strengths)
hamacher_sum(strengths) 	= @fastmath reduce((x, i) -> (2i * x - x - i) / (x * i - 1.0), strengths) =#

algebraic_sum(x, y) 		= (1 - x)y + x			#  Łukasiewicz t-conorm
bounded_sum(x, y) 			= min(1, x + y)
drastic_sum(x, y) 			= iszero(min(x, y)) ? max(x, y) : 1 # Dubois
einstein_sum(x, y) 			= x * y / (1 + x * y)
hamacher_sum(x, y) 			= (2y * x - x - y) / (x * y - 1)
S_Fodor(x, y)			 	= x + y < 1 ? max(x, y) : 0
